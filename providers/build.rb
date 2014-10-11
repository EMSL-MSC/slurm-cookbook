
require "digest"
require "tempfile"

def whyrun_supported?
  true
end

use_inline_resources

action :create do
    Chef::Log.warn @current_resource
    Chef::Log.warn @new_resource
    Chef::Log.warn node["slurm"]
	
	if @current_resource and @current_resource.path+"/.chef-check" == @new_resource.path+"/.chef-check"
		Chef::Log.warn "Repos are the same, nothing to do"
	else
		Chef::Log.warn "Need to build slurm and put it in "+@new_resource.path
		rc = build_slurm(download_slurm(), @new_resource.path)
		if rc.exitstatus == 0
			`touch #{@new_resource.path}/.chef-check`
		else
			Chef::Log.error "Slurm failed to build"
		end
	end

end

def download_slurm()
	tmp = Tempfile.new("slurm-tarball")
	path = tmp.path
	rf = remote_file path do
		headers( heads )
		mode    0600
		source  node["slurm"]["url"]
		action  :nothing
	end
	rf.run_action(:create)
	Chef::Log.warn "done getting file from web site"
	tmp
end

def build_slurm(tmpfile, output_dir)
	reader, writer = IO.pipe
	cpid = Process.fork do
		reader.close
		$stdout.reopen(writer)
		$stderr.reopen(writer)
		$stdin.reopen("/dev/null", "r")
		exec( "rpmbuild -ta --define '_rpmdir '"+output_dir+"' --with mysql "+tmpfile.path )
	end
	while not reader.eof?
		puts reader.read(128)
	end
	Process.waitpid(cpid)
	$?
end

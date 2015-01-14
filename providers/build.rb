
def whyrun_supported?
  true
end

use_inline_resources

action :create do
	if ::File.exists?(@new_resource.output_rpms+"/.chef-check")
		Chef::Log.warn "Repos are the same, nothing to do"
	else
		Chef::Log.warn "Need to build slurm and put it in "+@new_resource.output_rpms
		saved_tarball = @new_resource.output_rpms+"/"+::File.basename(node["slurm"]["url"])
		slurm_dl = Mixlib::ShellOut.new("curl -o "+saved_tarball+" "+node["slurm"]["url"])
		rpmbuild = Mixlib::ShellOut.new("rpmbuild -ta --define '_rpmdir "+@new_resource.output_rpms+"' "+@new_resource.rpmbuildopts+" "+saved_tarball)
		createrepo = Mixlib::ShellOut.new("createrepo "+@new_resource.output_rpms)
		check_file = Mixlib::ShellOut.new("touch "+@new_resource.output_rpms+"/.chef-check")
		Chef::Log.info slurm_dl.command
		if not slurm_dl.run_command
			Chef::Log.error slurm_dl.stderr
			slurm_dl.error!
		end
		Chef::Log.info rpmbuild.command
		if not rpmbuild.run_command
			Chef::Log.error rpmbuild.stderr
			rpmbuild.error!
		end
		Chef::Log.info createrepo.command
		if not createrepo.run_command
			Chef::Log.error createrepo.stderr
			createrepo.error!
		end
		if not check_file.run_command
			Chef::Log.error check_file.stderr
			check_file.error!
		else
			Chef::Log.info "completed slurm build"
		end
	end

end



def whyrun_supported?
  true
end

use_inline_resources

action :create do
    Chef::Log.warn @current_resource
    Chef::Log.warn @new_resource
    Chef::Log.warn node["slurm"]
	
	if @current_resource and @current_resource.output_rpms == @new_resource.output_rpms and ::File.exists(@current_resource.output_rpms+"/.chef-check")
		Chef::Log.warn "Repos are the same, nothing to do"
	else
		Chef::Log.warn "Need to build slurm and put it in "+@new_resource.output_rpms
		saved_tarball = @new_resource.output_rpms+"/"+::File.basename(node["slurm"]["url"])
		if not system("curl -o "+saved_tarball+" "+node["slurm"]["url"])
			Chef::Log.error "failed to download slurm"
		elsif not system("rpmbuild -ta --define '_rpmdir "+@new_resource.output_rpms+"' --with mysql --with munge "+saved_tarball)
			Chef::Log.error "failed to build slurm"
		elsif not system("createrepo "+@new_resource.output_rpms)
			Chef::Log.error "failed to create repository"
		elsif not system("touch "+@new_resource.output_rpms+"/.chef-check")
			Chef::Log.error "failed to add chef check"
		else
			Chef::Log.info "completed slurm build"
		end
	end

end


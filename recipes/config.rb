include_recipe "slurm::install"

template "slurm_conf" do
  path node['slurm']['configdir']+"/slurm.conf"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :config => node['slurm']['slurm']['config'],
    :nodes => node['slurm']['slurm']['nodes'],
    :partitions => node['slurm']['slurm']['partitions']
  )
end


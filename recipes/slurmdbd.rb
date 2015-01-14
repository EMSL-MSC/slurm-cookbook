include_recipe "slurm::config"

template "slurmdbd_conf" do
  path node['slurm']['configdir']+"/slurmdbd.conf"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :config => node['slurm']['slurmdbd']['config']
  )
  notifies :restart, 'service[slurmdbd]'
end

service 'slurmdbd' do
  service_name node['slurm']['service_db_name']
  supports [:start, :restart, :status, :stop]
end

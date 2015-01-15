include_recipe "slurm::config"

service 'slurm' do
  service_name node['slurm']['service_name']
  supports [:start, :restart, :status, :stop]
  subscribes :restart, 'template[slurm_conf]', :immediately
  action [ :enable, :start ]
end

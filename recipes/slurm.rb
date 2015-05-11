include_recipe "slurm::config"

node['slurm']['service_name'].each do |sname|
  service sname do
    service_name sname
    supports [:start, :restart, :status, :stop]
    subscribes :restart, 'template[slurm_conf]', :immediately
    action [ :enable, :start ]
  end
end

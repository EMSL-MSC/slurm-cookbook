node.default['slurm']['slurm']['config']['AccountingStorageType'] = 'accounting_storage/slurmdbd'

include_recipe "slurm::config"

node['slurm']['service_db_name'].each do |sname|
  service sname do
    service_name sname
    supports [:start, :restart, :status, :stop]
    subscribes :restart, 'template[slurmdbd_conf]', :immediately
    action [ :enable, :start ]
  end
end


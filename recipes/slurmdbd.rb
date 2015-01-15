node.default['slurm']['slurm']['config']['AccountingStorageType'] = 'accounting_storage/slurmdbd'
include_recipe "slurm::config"

service 'slurmdbd' do
  service_name node['slurm']['service_db_name']
  supports [:start, :restart, :status, :stop]
  subscribes :restart, 'template[slurmdbd_conf]', :immediately
  action [ :enable, :start ]
end

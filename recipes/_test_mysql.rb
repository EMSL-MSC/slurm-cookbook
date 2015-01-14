node.default['slurm']['rpmbuildopts'] += " --with mysql"
node.default['slurm']['slurmdbd']['config']['AccountingStorageType'] = "accounting_storage/mysql"
node.default['mysql']['server_root_password'] = "Please-Dont-Use-In-Production"
node.default['mysql']['server_debian_password'] = "Please-Dont-Use-In-Production"
node.default['mysql']['server_repl_password'] = "Please-Dont-Use-In-Production"

mysql_client 'default'
mysql_chef_gem 'default'
mysql_service 'default' do
  initial_root_password node['mysql']['server_root_password']
  action [:create, :start]
end

slurmdbd_user = "slurm"
slurmdbd_pass = "slurm"
slurmdbd_db = "slurmdb"
slurmdbd_host = "127.0.0.1"

mysql_connection_info = {
  :host => slurmdbd_host,
  :username => 'root',
  :password => node['mysql']['server_root_password']
}

mysql_database slurmdbd_db do
  connection mysql_connection_info
  action :create
end

mysql_database_user slurmdbd_user do
  connection mysql_connection_info
  password slurmdbd_pass
  action :create
end

mysql_database_user slurmdbd_user do
  connection mysql_connection_info
  password slurmdbd_pass
  database_name slurmdbd_db
  host '%'
  privileges [:all]
  action :grant
end

include_recipe "slurm::slurmdbd"
include_recipe "slurm::slurm"

include_recipe "slurm::config"

if node['slurm']['slurmdbd']['localdb']
  case node['platform_family']
  when 'debian'
    package 'build-essential' do
      action :nothing
    end.run_action(:install)
  when 'rhel', 'centos', 'fedora'
    package '@Development Tools' do
      action :nothing
    end.run_action(:install)
  else
    Chef::Log.error("Unsupported Platform Family: #{node['platform_family']}")
  end
  package node['mysql']['client_devel_package'] do
    action :nothing
  end.run_action(:install)

  chef_gem "mysql"

  mysql_service 'default' do
    version node['mysql']['version']
    package_name node['mysql']['package_name']
    port node['mysql']['port']
    data_dir node['mysql']['data_dir']
    allow_remote_root node['mysql']['allow_remote_root']
    root_network_acl node['mysql']['root_network_acl']
    remove_anonymous_users node['mysql']['remove_anonymous_users']
    remove_test_database node['mysql']['remove_test_database']
    server_root_password node['mysql']['server_root_password']
    server_repl_password node['mysql']['server_repl_password']
    action :create
  end

  slurmdbd_user = "slurm"
  slurmdbd_pass = "slurm"
  slurmdbd_db = "slurmdb"
  slurmdbd_host = "localhost"

  if node['slurm']['slurmdbd']['config'].has_key?("StorageHost")
    slurmdbd_host = node['slurm']['slurmdbd']['config']['StorageHost']
  end
  if node['slurm']['slurmdbd']['config'].has_key?("StorageLoc")
    slurmdbd_db = node['slurm']['slurmdbd']['config']['StorageLoc']
  end
  if node['slurm']['slurmdbd']['config'].has_key?("StorageUser")
    slurmdbd_user = node['slurm']['slurmdbd']['config']['StorageUser']
  end
  if node['slurm']['slurmdbd']['config'].has_key?("StoragePass")
    slurmdbd_pass = node['slurm']['slurmdbd']['config']['StoragePass']
  end

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
end

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

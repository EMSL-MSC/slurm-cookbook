#
# Cookbook Name:: slurm
# Attributes:: default
#
# Copyright 2013-2014, Battelle, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
default['slurm']['version'] = "14.03.8"
default['slurm']['cluster_name'] = "localhost"

# ControlMachine=localhost
# ClusterName=localhost
# AuthType=auth/munge
# SelectType=select/cons_res
# SelectTypeParameters=CR_CORE
default['slurm']['slurm']['config'] = {
  "ControlMachine" => "localhost",
  "ClusterName" => "localhost",
  "AuthType" => "auth/munge",
  "AccountingStorageType" => "accounting_storage/slurmdbd"
}
# NodeName=localhost Procs=8 State=DRAIN
default['slurm']['slurm']['nodes'] = [
  {
    "NodeName" => "localhost",
    "Procs" => "1",
    "State" => "DRAIN"
  },
]
# PartitionName=local Nodes=localhost Default=YES Shared=YES
default['slurm']['slurm']['partitions'] = [
  {
    "PartitionName" => "local",
    "Nodes" => "localhost",
    "Default" => "YES",
    "Shared" => "YES"
  },
]

# AuthType=auth/munge
# DbdHost=localhost
# DbdBackupHost=localhost
# StorageHost=localhost
# StorageLoc=slurmdb
# StorageUser=slurm
# StoragePass=slurm
# StorageType=accounting_storage/mysql
# LogFile=/var/log/slurmdbd.log
default['slurm']['slurmdbd']['config'] = {
  "AuthType" => "auth/munge",
  "DbdHost" => "localhost",
  "StorageHost" => "localhost",
  "StorageLoc" => "slurmdb",
  "StorageUser" => "slurm",
  "StoragePass" => "slurm",
  "StorageType" => "accounting_storage/mysql",
  "LogFile" => "/var/log/slurmdbd.log"
}

# for local mysqldb setup
default['slurm']['slurmdbd']['localdb'] = true
default['mysql']['port'] = '3306'
default['mysql']['package_name'] = 'mysql-server'
default['mysql']['data_dir'] = '/data'
default['mysql']['root_network_acl'] = ['127.0.0.1/32']
default['mysql']['allow_remote_root'] = false
default['mysql']['remove_anonymous_users'] = false
default['mysql']['remove_test_database'] = false
default['mysql']['server_root_password'] = 'password'
default['mysql']['server_repl_password'] = 'password'

case node['platform_family']
when 'rhel', 'centos'
  default['slurm']['pkgrepos'] = ['yum-epel']
  default['slurm']['packages'] = ['slurm', 'slurm-slurmdbd', 'munge', 'slurm-plugins']
  default['slurm']['configdir'] = '/etc/slurm-llnl'
  default['slurm']['service_name'] = 'slurm'
  default['slurm']['service_db_name'] = 'slurmdbd'
  default['mysql']['version'] = '5.1'
  default['mysql']['client_devel_package'] = 'mysql-devel'
when 'fedora'
  default['slurm']['packages'] = ['slurm', 'slurm-slurmdbd', 'munge', 'slurm-plugins']
  default['slurm']['configdir'] = '/etc/slurm'
  default['slurm']['service_name'] = 'slurm'
  default['slurm']['service_db_name'] = 'slurmdbd'
  default['mysql']['version'] = '5.5'
  default['mysql']['client_devel_package'] = 'mysql-devel'
when 'debian'
  default['slurm']['packages'] = ['slurm-llnl', 'slurm-llnl-basic-plugins', 'slurm-llnl-slurmdbd', 'munge']
  default['slurm']['configdir'] = '/etc/slurm-llnl'
  default['slurm']['service_name'] = 'slurm-llnl'
  default['slurm']['service_db_name'] = 'slurm-llnl-slurmdbd'
  default['mysql']['version'] = '5.5'
  default['mysql']['client_devel_package'] = 'libmysqlclient-dev'
else
  Chef::Log.error("Unsupported Platform Family: #{node['platform_family']}")
end


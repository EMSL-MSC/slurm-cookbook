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
default['slurm']['version'] = "14.11.3"
default['slurm']['cluster_name'] = "localhost"
default['slurm']['url'] = "http://www.schedmd.com/download/latest/slurm-#{node['slurm']['version']}.tar.bz2"

# ControlMachine=localhost
# ClusterName=localhost
# AuthType=auth/munge
# SelectType=select/cons_res
# SelectTypeParameters=CR_CORE
default['slurm']['slurm']['config'] = {
  "ControlMachine" => "localhost",
  "ClusterName" => "localhost",
  "AuthType" => "auth/munge",
  "AccountingStorageType" => "accounting_storage/none"
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
  "StorageHost" => "127.0.0.1",
  "StorageLoc" => "slurmdb",
  "StorageUser" => "slurm",
  "StoragePass" => "slurm",
  "StorageType" => "accounting_storage/none",
  "LogFile" => "/var/log/slurmdbd.log"
}

case node['platform_family']
when 'rhel', 'fedora'
  default['slurm']['packages']['build'] = [
      'gcc',
      'hwloc',
      'hwloc-devel',
      'make',
      'gtk2-devel',
      'pkgconfig',
      'ncurses-devel',
      'readline-devel',
      'openssl-devel',
      'numactl-devel',
      'glib2-devel',
      'perl-devel',
      'perl(ExtUtils::MakeMaker)',
      'lua-devel',
      'pam-devel',
      'rpm-build',
      'munge-devel',
      'glibc-devel'
  ]
else
  default['slurm']['packages']['build'] = []
end
default['slurm']['rpmbuildopts'] = "--with numactl --with hwloc --with munge"

case node['platform_family']
when 'rhel'
  case node['platform']
  when 'centos'
    default['slurm']['buildit'] = true
    default['slurm']['pkgrepos'] = ['yum-epel']
    default['slurm']['packages']['slurm'] = ['slurm', 'slurm-munge', 'slurm-slurmdbd', 'munge', 'slurm-plugins']
    default['slurm']['configdir'] = '/etc/slurm'
    default['slurm']['service_name'] = 'slurm'
    default['slurm']['service_db_name'] = 'slurmdbd'
  end
when 'fedora'
  default['slurm']['buildit'] = true
  default['slurm']['packages']['slurm'] = ['slurm', 'slurm-munge', 'slurm-slurmdbd', 'munge', 'slurm-plugins']
  default['slurm']['configdir'] = '/etc/slurm'
  default['slurm']['service_name'] = 'slurm'
  default['slurm']['service_db_name'] = 'slurmdbd'
when 'debian'
  default['slurm']['buildit'] = false
  default['slurm']['packages']['slurm'] = ['slurm-llnl', 'slurm-llnl-basic-plugins', 'slurm-llnl-slurmdbd', 'munge']
  # we don't build for this OS
  default['slurm']['packages']['build'] = []
  default['slurm']['configdir'] = '/etc/slurm-llnl'
  default['slurm']['service_name'] = 'slurm-llnl'
  default['slurm']['service_db_name'] = 'slurm-llnl-slurmdbd'
else
  Chef::Log.error("Unsupported Platform Family: #{node['platform_family']}")
end

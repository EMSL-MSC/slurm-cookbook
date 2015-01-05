node.default['auto-update']['enabled'] = true
include_recipe 'apt'
include_recipe 'yum'
include_recipe 'yum-centos'

execute "yum -y distribution-synchronization" do
end if node['platform_family'] == 'rhel'

include_recipe 'auto-update'

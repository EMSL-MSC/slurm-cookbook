node.default['auto-update']['enabled'] = true
if node['platform_family'] == 'debian'
  include_recipe 'apt'
end
if node['platform_family'] == 'rhel'
  include_recipe 'yum'
  if node['platform'] == 'centos'
    include_recipe 'yum-centos'
  end
end

execute "yum -y distribution-synchronization" do
end if node['platform_family'] == 'rhel'

include_recipe 'auto-update'

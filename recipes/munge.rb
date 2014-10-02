
package "munge"

if node['slurm'].has_key?("mungekey")
  if node['slurm']['mungekey'].has_key?("type")
    case node['slurm']['mungekey']['type']
    when 'vault'
      chef_gem "chef-vault"
      require 'chef-vault'
      key_item = ChefVault::Item.load("slurm", "mungekey")
      key_hash = key_item.to_hash()
    when 'databag'
      key_item = data_bag_item("slurm", "mungekey")
      key_hash = key_item.to_hash()
    else
      Chef::Log.error("munge key type needs to be one of vault or databag.")
    end
  else
    Chef::Log.error("node[:slurm][:mungekey] needs a type attribute.")
  end
  # wait this is binary and needs to be a file
  template "mungekey" do
    user "munge"
    group "munge"
    mode "0400"
    path "/etc/munge/munge.key"
    source "mungekey.erb"
    variables({
      :data => key_hash['data']
    })
  end
else
  bash "create-munge-key" do
    user "root"
    cwd "/tmp"
    code <<-EOH
    test -e /etc/munge/munge.key || create-munge-key
    EOH
    notifies :restart, 'service[munge]'
  end
end

directory "/var/log" do
  mode '0755'
end

service 'munge' do
  service_name 'munge'
  supports [:start, :restart, :status, :stop]
end

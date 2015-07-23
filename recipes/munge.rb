case node['platform_family']
when 'rhel'
  include_recipe "yum-epel"
end

directory "/var/log" do
  mode '0755'
end

package "munge"

if node['slurm'].has_key?("mungekey")
  if node['slurm']['mungekey'].has_key?("type")
    case node['slurm']['mungekey']['type']
    when 'vault'
      chef_gem "chef-vault"
      require 'chef-vault'
      key_item = chef_vault_item("slurm", "mungekey")
    when 'databag'
      secret_key = Chef::EncryptedDataBagItem.load_secret(Chef::Config['encrypted_data_bag_secret'])
      key_item = Chef::EncryptedDataBagItem.load("slurm", "mungekey", secret_key)
    else
      Chef::Log.error("munge key type needs to be one of vault or databag.")
    end
  else
    Chef::Log.error("node[:slurm][:mungekey] needs a type attribute.")
  end
  key_hash = key_item.to_hash()
  # wait this is binary and needs to be a file
  template "mungekey.ascii" do
    user "munge"
    group "munge"
    mode "0400"
    path "/etc/munge/munge.key.base64"
    notifies :run, "bash[create-munge-key]"
    source "mungekey.erb"
    variables({
      :data => key_hash['mungekey']
    })
  end
  bash "create-munge-key" do
    user "root"
    cwd "/tmp"
    code "base64 -d < /etc/munge/munge.key.base64 > /etc/munge/munge.key"
    action :nothing
  end
else
  bash "create-munge-key" do
    user "root"
    cwd "/tmp"
    code "create-munge-key"
    not_if "test -e /etc/munge/munge.key"
  end
end

file "mungekey" do
  user "munge"
  group "munge"
  mode "0400"
  path "/etc/munge/munge.key"
end

service 'munge' do
  service_name 'munge'
  supports [:enable, :start, :restart, :status, :stop]
  subscribes :restart, 'bash[create-munge-key]', :immediately
  action :enable
end


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
    path "/etc/munge/munge.key.base64"
    notifies :run, "execute[convert-mungekey]"
    source "mungekey.erb"
    variables({
      :data => key_hash['mungekey']
    })
  end
  execute "convert-mungekey" do
    command "base64 -d < /etc/munge/munge.key.base64 > /etc/munge/munge.key"
    action :nothing
  end
else
  bash "create-munge-key" do
    user "root"
    cwd "/tmp"
    code "create-munge-key"
    not_if "test -e /etc/munge/munge.key"
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

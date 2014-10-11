
if node['slurm'].has_key?('buildit') and node['slurm']['buildit']
  if node['platform_family'] == 'rhel' or node['platform_family'] == 'centos'
    include_recipe "yum-epel::default"
  end
  case node['platform_family']
    when 'rhel', 'centos', 'fedora'
      directory "/opt/local-slurm" do
        owner "root"
        group "root"
        mode "0755"
        action :create
      end
      slurm_build "slurm" do
        version node['slurm']['version']
        url node['slurm']['source_url']
        output_rpms "/opt/local-slurm"
      end
      yum_repository 'local-slurm' do
        description "Local Slurm Repository"
        baseurl "file:///opt/local-slurm"
        gpgcheck 0
        enabled 1
        priority 99
        action :create
      end
  else
    Chef::Log.warn("Building slurm with platform family, #{node['platform_family']} is not yet not supported by this cookbook")
  end
end

node['slurm']['packages'].each do |name|
  package name
end


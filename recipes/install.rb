include_recipe 'munge'

if node['slurm'].has_key?('buildit') and node['slurm']['buildit']
  case node['platform_family']
    when 'rhel', 'fedora'
      node['slurm']['packages']['build'].each do |pkg|
        package pkg
      end
      directory "/opt/local-slurm" do
        owner "root"
        group "root"
        mode "0755"
        action :create
      end
      package "createrepo"
      slurm_build "slurm" do
        rpmbuildopts node['slurm']['rpmbuildopts']
        version node['slurm']['version']
        url node['slurm']['source_url']
        output_rpms "/opt/local-slurm"
      end
      yum_repository 'local-slurm' do
        description "Local Slurm Repository"
        baseurl "file:///opt/local-slurm"
        gpgcheck false
        enabled true
        priority "99"
        action :create
      end
  else
    Chef::Log.warn("Building slurm with platform family, #{node['platform_family']} is not yet not supported by this cookbook")
  end
end

node['slurm']['packages']['slurm'].each do |name|
  package name
end


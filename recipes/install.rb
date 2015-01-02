include_recipe 'slurm::munge'

case node['platform_family']
when 'debian'
  package 'build-essential' do
    action :nothing
  end.run_action(:install)
when 'rhel', 'fedora'
  %w{
    createrepo
    gcc
    glibc-devel
    make
    gtk2-devel
    pkgconfig
    ncurses-devel
    readline-devel
    openssl-devel
    mysql-devel
    numactl-devel
    hwloc-devel
    glib2-devel
    perl-devel
    perl(ExtUtils::MakeMaker)
    lua-devel
    pam-devel
    rpm-build
    munge-devel
  }.each do |pkg|
    package pkg do
      action :nothing
    end.run_action(:install)
  end
else
  Chef::Log.error("Unsupported Platform Family: #{node['platform_family']}")
end

if node['slurm'].has_key?('buildit') and node['slurm']['buildit']
  case node['platform_family']
    when 'rhel', 'fedora'
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
        gpgcheck false
        enabled true
        priority "99"
        action :create
      end
  else
    Chef::Log.warn("Building slurm with platform family, #{node['platform_family']} is not yet not supported by this cookbook")
  end
end

node['slurm']['packages'].each do |name|
  package name
end


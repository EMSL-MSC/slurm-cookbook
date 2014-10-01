
if node['slurm'].has_key?("pkgrepos")
  case node['platform_family']
    when 'rhel'
      include_recipe "yum-epel::default"
  else
    Chef::Log.warn("Adding the #{node['platform_family']} slurm repository is not yet not supported by this cookbook")
  end
end
node['slurm']['packages'].each do |name|
  package name
end


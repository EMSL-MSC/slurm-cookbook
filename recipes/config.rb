include_recipe 'slurm::install'
include_recipe 'slurm::munge'

hostsfile_entry node['ipaddress'] do
  hostname  node['hostname']
  unique    true
end

node_lines = []
node['slurm']['slurm']['nodes'].each do |line_hash|
  line = ""
  line_hash.keys.each do |key|
    if not line_hash[key].nil?
      line += key + "=" + line_hash[key] + " "
    end
  end
  node_lines.push(line)
end

partition_lines = []
node['slurm']['slurm']['partitions'].each do |part_hash|
  part = ""
  part_hash.keys.each do |key|
    if not part_hash[key].nil?
      part += key + "=" + part_hash[key] + " "
    end
  end
  partition_lines.push(part)
end

template "slurm_conf" do
  path node['slurm']['configdir']+"/slurm.conf"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :config => node['slurm']['slurm']['config'],
    :nodes => node_lines,
    :partitions => partition_lines
  )
  notifies :restart, 'service[slurm]'
end


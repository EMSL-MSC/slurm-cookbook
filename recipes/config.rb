include_recipe 'slurm::install'
include_recipe 'slurm::munge'

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

template "/etc/default/slurm"
template "/etc/default/slurmd"
template "/etc/default/slurmctld"
template "/etc/default/slurmdbd"
directory "/var/run/slurm"

template "slurmdbd_conf" do
  path node['slurm']['configdir']+"/slurmdbd.conf"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :config => node['slurm']['slurmdbd']['config']
  )
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
end


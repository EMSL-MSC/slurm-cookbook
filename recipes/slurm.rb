include_recipe "slurm::config"

service 'slurm' do
  service_name node['slurm']['service_name']
  supports [:start, :restart, :status, :stop]
end

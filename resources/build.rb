actions :create
default_action :create

attribute :name,            :kind_of => String, :name_attribute => true
attribute :rpmbuildopts,    :kind_of => String, :default => "--with munge"
attribute :version,         :regex => /^\d+(\.\d+)+$/, :default => node['slurm']['version']
attribute :url,             :regex => /^[[:alpha:]]+:\/\/([:alpha:]|\/)+$/, :default => "http://www.schedmd.com/download/latest/slurm-#{node['slurm']['version']}.tar.bz2"
attribute :output_rpms,     :regex => /^[\w|\-|\/]+$/, :default => "/opt/slurm-local"

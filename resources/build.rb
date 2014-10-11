actions :create
default_action :create

attribute :name,            :kind_of => String, :name_attribute => true
attribute :version,         :regex => /^\d+(\.\d+)+$/, :default => "14.03.8"
attribute :url,             :regex => /^[[:alpha:]]+:\/\/([[:alpha:]]|\/)+$/, :default => "http://www.schedmd.com/download/latest/slurm-14.03.8.tar.bz2"
attribute :output_rpms,     :regex => /^([[:alpha:]]|\/)+$/, :default => "http://www.schedmd.com/download/latest/slurm-14.03.8.tar.bz2"

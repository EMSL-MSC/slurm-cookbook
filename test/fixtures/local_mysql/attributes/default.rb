default['slurm']['rpmbuildopts'] += " --with mysql"
default['slurm']['slurmdbd']['config']['StorageType'] = "accounting_storage/mysql"
default['mysql']['server_root_password'] = "Please-Dont-Use-In-Production"
default['mysql']['server_debian_password'] = "Please-Dont-Use-In-Production"
default['mysql']['server_repl_password'] = "Please-Dont-Use-In-Production"

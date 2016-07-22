name             'slurm'
maintainer       'PNNL'
maintainer_email 'david.brown@pnnl.gov'
license          'All rights reserved'
description      'Installs/Configures slurm'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.0'

depends 'build-essential'
depends 'yum-epel'
depends 'yum'
depends 'mariadb'
depends 'database'
depends 'mysql'
depends 'mysql2_chef_gem'
depends 'hostsfile'
depends 'munge'
depends 'selinux'

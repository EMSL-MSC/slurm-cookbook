name             'slurm'
maintainer       'PNNL'
maintainer_email 'david.brown@pnnl.gov'
license          'All rights reserved'
description      'Installs/Configures slurm'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'yum-epel'
depends 'mysql'
depends 'database'

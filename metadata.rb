name 'test-redirecttoolserver'
maintainer 'Gannett Co., Inc'
maintainer_email 'paas-delivery@gannett.com'
license ' Copyright (c) 2016 Gannett Co., Inc, All Rights Reserved.'
description 'Installs/Configures test-redirecttoolserver'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.0'

# add any cookbook dependencies here
# depends 'other_cookbook_name'

depends 'gdp-base-linux', '=3.0.1'
depends 'nginx', '= 2.7.4'
depends 'php', '>= 1.5.0'
depends 'php-fpm', '>= 0.6.10'
depends 'selinux', '>= 0.7'
depends 'selinux_policy', '>= 0.7.3'
depends 'build-essential', '>= 2.2.3'
depends 'ark', '>= 0.9.0'
depends 'openssl', '>= 4.4.0'
depends 'database', '>= 1.6.0'
depends 'mysql', '>= 6.0'
depends 'mysql2_chef_gem', '>= 1.0.1'


supports 'centos'

source_url 'https://github.com/GannettDigital/chef-test-redirecttoolserver'
issues_url 'https://github.com/GannettDigital/chef-test-redirecttoolserver/issues'

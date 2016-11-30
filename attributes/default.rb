#
# Cookbook Name:: wordpress
# Recipe:: database
# Author:: Lucas Hansen (<lucash@opscode.com>)
# Author:: Julian C. Dunn (<jdunn@getchef.com>)
# Author:: Craig Tracey (<craigtracey@gmail.com>)
#
# Copyright (C) 2013, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#


# General settings
default['redirecttool']['version'] = 'latest'

default['redirecttool']['db']['instance_name'] = 'default'
default['redirecttool']['db']['name'] = 'redirecttooldb'
default['redirecttool']['db']['user'] = 'redirecttooluser'
default['redirecttool']['db']['pass'] = nil 

# By default, generated using openssl cookbook.
default['redirecttool']['db']['prefix'] = 'wp_'
default['redirecttool']['db']['host'] = 'localhost'
default['redirecttool']['db']['allowed_hosts'] = nil
default['redirecttool']['db']['port'] = '3306' 

# Must be a string
default['redirecttool']['db']['charset'] = 'utf8'
default['redirecttool']['db']['collate'] = ''
default['redirecttool']['db']['mysql_version'] = '5.6'

# Databag and item to use for redirecttool DB root user password.
default['redirecttool']['db']['databag_name'] = 'mysql'
default['redirecttool']['db']['databag_item'] = 'test_master'

default['php']['packages'] = %w( php56u php56u-devel php56u-cli php56u-pear php56u-mysqlnd php56u-opcache php56u-pecl-imagick )
default['php-fpm']['package_name'] = 'php56u-fpm'
default['php-fpm']['service_name'] = 'php-fpm'
default['php-fpm']['emergency_restart_threshold'] = 10
default['php-fpm']['emergency_restart_interval'] = '1m'
default['php-fpm']['process_control_timeout'] = '10s'

default['redirecttool']['php-fpm']['process_manager'] = 'dynamic'
default['redirecttool']['php-fpm']['max_children'] = 20
default['redirecttool']['php-fpm']['start_servers'] = 5
default['redirecttool']['php-fpm']['min_spare_servers'] = 5
default['redirecttool']['php-fpm']['max_spare_servers'] = 20
default['redirecttool']['php-fpm']['max_requests'] = 200


default['redirecttool']['install']['user'] = 'nginx'
default['redirecttool']['install']['group'] = 'nginx'



default['redirecttool']['php_options'] = { 'php_admin_value[upload_max_filesize]' => '50M', 'php_admin_value[post_max_size]' => '55M' }

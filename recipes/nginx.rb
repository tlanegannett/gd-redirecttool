node.set_unless['php-fpm']['pools'] = []

include_recipe 'selinux_policy::install'

selinux_policy_module 'phpfpmlocal' do
  content <<-eos
    module php-fpm 1.0;
    require {
      type tor_port_t;
      type httpd_t;
      class tcp_socket name_bind;
    }
    #============= httpd_t ==============
    allow httpd_t tor_port_t:tcp_socket name_bind;
  eos
  action :deploy
end

include_recipe 'php'
include_recipe 'php-fpm'

php_fpm_pool 'redirecttool' do
  listen '127.0.0.1:9001'
  user node['redirecttool']['install']['user']
  group node['redirecttool']['install']['group']
  listen_owner node['redirecttool']['install']['user']
  listen_group node['redirecttool']['install']['group']
  php_options node['redirecttool']['php_options']
  process_manager node['redirecttool']['php-fpm']['process_manager']
  max_children node['redirecttool']['php-fpm']['max_children']
  start_servers node['redirecttool']['php-fpm']['start_servers']
  min_spare_servers node['redirecttool']['php-fpm']['min_spare_servers']
  max_spare_servers node['redirecttool']['php-fpm']['max_spare_servers']
  max_requests node['redirecttool']['php-fpm']['max_requests']
end

node.set_unless['nginx']['default_site_enabled'] = false

selinux_policy_module 'nginx' do
  content <<-eos
    module nginx 1.0;
    require {
      type tor_port_t;
      type httpd_t;
      class tcp_socket name_connect;
    }
    #============= httpd_t ==============
    #!!!! This avc is allowed in the current policy
    allow httpd_t tor_port_t:tcp_socket name_connect;
  eos
  action :deploy
end

include_recipe 'nginx'#
# Cookbook Name:: test-redirecttoolserver
# Recipe:: nginx
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

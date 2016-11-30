#
# Cookbook Name:: test-redirecttoolserver
# Recipe:: database
#
# Copyright (c) 2016 The Authors, All Rights Reserved.


db = node['redirecttool']['db']

mysql_client 'default' do
  version db['mysql_version']
  action :create
end

mysql2_chef_gem 'default' do
  client_version db['mysql_version']
  action :install
end

::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
::Chef::Recipe.send(:include, redirecttool::Helpers)

node.set_unless['redirecttool']['db']['pass'] = secure_password
node.save unless Chef::Config[:solo]

opts = data_bag_item(node['redirecttool']['db']['databag_name'], node['redirecttool']['db']['databag_item'])

if local_host? db['host']

  # The following is required for the mysql community cookbook to work properly
  include_recipe 'selinux::disabled' if node['platform_family'] == 'rhel'

  mysql_service db['instance_name'] do
    port db['port']
    version db['mysql_version']
    initial_root_password opts['password']
    action [:create, :start]
  end

  mysql_config db['instance_name'] do
    source 'mysql_extra_settings.erb'
    action :create
    notifies :restart, "mysql_service[#{db['instance_name']}]", :immediately
  end

  socket = "/var/run/mysql-#{db['instance_name']}/mysqld.sock"

  if node['platform_family'] == 'debian'
    link '/var/run/mysqld/mysqld.sock' do
      to socket
      not_if 'test -f /var/run/mysqld/mysqld.sock'
    end
  elsif node['platform_family'] == 'rhel'
    link '/var/lib/mysql/mysql.sock' do
      to socket
      not_if 'test -f /var/lib/mysql/mysql.sock'
    end
  end

  mysql_connection_info = {
    :host     => 'localhost',
    :username => opts['root_username'] || 'root',
    :socket   => socket,
    :password => opts['password']
  }

  node.set_unless['redirecttool']['db']['allowed_hosts'] = 'localhost'

else

  selinux_policy_boolean 'httpd_can_network_connect_db' do
    value true
    notifies :restart, 'service[nginx]', :immediate
  end

  selinux_policy_boolean 'httpd_can_network_connect' do
    value true
    notifies :restart, 'service[nginx]', :immediate
  end

  node.set_unless['redirecttool']['db']['allowed_hosts'] = find_allowed_hosts? node['ipaddress']

  mysql_connection_info = {
    :host     => db['host'],
    :username => opts['root_username'] || 'root',
    :password => opts['password']
  }

end

mysql_database db['name'] do
  connection  mysql_connection_info
  action      :create
end

mysql_database_user db['user'] do
  connection    mysql_connection_info
  host          node['redirecttool']['db']['allowed_hosts']
  action        :drop
end

mysql_database_user db['user'] do
  connection    mysql_connection_info
  password      opts['user_password'] || node['redirecttool']['db']['pass']
  host          node['redirecttool']['db']['allowed_hosts']
  action        :create
end

mysql_database_user db['user'] do
  connection    mysql_connection_info
  database_name db['name']
  privileges    [:all]
  action        :grant
end
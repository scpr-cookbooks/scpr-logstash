#
# Cookbook Name:: scpr-logstash
# Recipe:: default
#
# Copyright (c) 2014 Southern California Public Radio, All Rights Reserved.

# make sure our packages are up to date
include_recipe "apt"

# -- Install Java -- #

include_recipe "java"

# -- Install Elasticsearch -- #

if node.scpr_logstash.install_elasticsearch
  # FIXME: this should be using scpr-elasticsearch
  include_recipe "scpr-elasticsearch"
end

# -- Install Logstash -- #

logstash_instance node.scpr_logstash.name do
  action :create
end

logstash_service node.scpr_logstash.name do
  action :enable
end

# write out our logstash-forwarder cert/key files
["logstash_forwarder.crt","logstash_forwarder.key"].each do |f|
  cookbook_file "#{node.scpr_logstash.lumberjack_ssl_path}/#{f}" do
    action  :create
    owner   'root'
    mode    0644
  end
end

config_opts = {
  elasticsearch_protocol:   node.scpr_logstash.elasticsearch_protocol,
  lumberjack_port:          node.scpr_logstash.lumberjack_port,
  lumberjack_cert_path:     node.scpr_logstash.lumberjack_ssl_path,
}

# what ES connection method are we using?
if node.scpr_logstash.elasticsearch_embedded
  config_opts[:elasticsearch_embedded]  = node.scpr_logstash.elasticsearch_embedded
elsif node.scpr_logstash.elasticsearch_cluster
  config_opts[:elasticsearch_cluster]   = node.scpr_logstash.elasticsearch_cluster
else
  config_opts[:elasticsearch_ip]        = node.scpr_logstash.elasticsearch_ip
end

logstash_config node.scpr_logstash.name do
  action              :create
  templates           node.scpr_logstash.config_templates
  templates_cookbook  "scpr-logstash"
  variables           config_opts
end

logstash_pattern node.scpr_logstash.name do
  action              :create
  templates           node.scpr_logstash.pattern_templates
  templates_cookbook  "scpr-logstash"
end

if node.scpr_logstash.kibana
  include_recipe "scpr-logstash::kibana"
end


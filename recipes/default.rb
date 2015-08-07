#
# Cookbook Name:: scpr-logstash
# Recipe:: default
#

# -- Install Java -- #

include_recipe "scpr-java"

# -- Install Elasticsearch -- #

if node.scpr_logstash.install_elasticsearch
  include_recipe "scpr-elasticsearch"
end

# -- Install Logstash -- #

# Set basedir, so that we know we're using the same setting logstash is
node.override['logstash']['instance'][node.scpr_logstash.name]['basedir'] = node.scpr_logstash.basedir
logstash_dir = "#{node.scpr_logstash.basedir}/#{node.scpr_logstash.name}"

logstash_instance node.scpr_logstash.name do
  action      :create
  version     node.scpr_logstash.version
  source_url  node.scpr_logstash.source_url
  checksum    node.scpr_logstash.checksum
end

logstash_service node.scpr_logstash.name do
  action :enable
end

# find our databag item for the logstash-forwarder cert
cert = begin data_bag_item(node.scpr_logstash.databag,node.scpr_logstash.databag_item) rescue nil end

if cert
  file "#{node.scpr_logstash.lumberjack_ssl_path}/logstash_forwarder.crt" do
    action  :create
    mode    0644
    content cert['cert']
  end

  file "#{node.scpr_logstash.lumberjack_ssl_path}/logstash_forwarder.key" do
    action  :create
    mode    0644
    content cert['key']
  end
end

# Write our elasticsearch mapping file
cookbook_file "#{logstash_dir}/etc/es-mapping.json" do
  action  :create
  mode    0644
end

config_opts = {
  elasticsearch_protocol:   node.scpr_logstash.elasticsearch_protocol,
  lumberjack_port:          node.scpr_logstash.lumberjack_port,
  lumberjack_cert_path:     node.scpr_logstash.lumberjack_ssl_path,
  logstash_dir:             logstash_dir,
}

# what ES connection method are we using?
if node.scpr_logstash.elasticsearch_cluster
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

if node.scpr_logstash.consul
  include_recipe "scpr-consul"

  consul_service_def "logstash" do
    action    :create
    notifies  :reload, "service[consul]"
  end
end

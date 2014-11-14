default.scpr_logstash.name = "scpr"

default.scpr_logstash.config_templates = {
  'input_lumberjack'        => 'config/input_lumberjack.conf.erb',
  'input_syslog'            => 'config/input_syslog.conf.erb',
  #'output_stdout'           => 'config/output_stdout.conf.erb',
  'output_elasticsearch'    => 'config/output_elasticsearch.conf.erb',
  'filter_nginx'            => 'config/filter_nginx.conf.erb',
}

default.scpr_logstash.pattern_templates = {
  'nginx'   => 'patterns/nginx.erb'
}

default.scpr_logstash.elasticsearch_ip = node.ipaddress
default.scpr_logstash.elasticsearch_protocol = "http"
default.scpr_logstash.version     = "1.4.2"
default.scpr_logstash.source_url  = "https://download.elasticsearch.org/logstash/logstash/logstash-1.4.2.tar.gz"
default.scpr_logstash.elasticsearch_embedded = false

default.scpr_logstash.lumberjack_port = "5960"

default.scpr_logstash.lumberjack_ssl_path = "/etc"

default.scpr_logstash.kibana = true

#----------

include_attribute "logstash"


#----------

include_attribute "elasticsearch"

default.elasticsearch.version = "1.4.0"
default.elasticsearch.zen.ping.multicast.enabled = false
default.elasticsearch.download_url  = "http://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.4.0.tar.gz"

default.elasticsearch.custom_config['http.cors.enabled'] = true

#----------

include_attribute "java"

default.java.install_flavor = "oracle"
default.java.jdk_version = 7
default.java.oracle.accept_oracle_download_terms = true
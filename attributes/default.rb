default.scpr_logstash.name          = "scpr"
default.scpr_logstash.basedir       = "/opt/logstash"

default.scpr_logstash.databag       = "certs"
default.scpr_logstash.databag_item  = "logstash_forwarder"

default.scpr_logstash.config_templates = {
  'input_lumberjack'        => 'config/input_lumberjack.conf.erb',
  'input_syslog'            => 'config/input_syslog.conf.erb',
  'output_elasticsearch'    => 'config/output_elasticsearch.conf.erb',
  'filter_nginx'            => 'config/filter_nginx.conf.erb',
}

default.scpr_logstash.pattern_templates = {
  'nginx'   => 'patterns/nginx.erb'
}

default.scpr_logstash.install_elasticsearch   = false
default.scpr_logstash.elasticsearch_cluster   = nil
default.scpr_logstash.elasticsearch_ip        = node.ipaddress
default.scpr_logstash.elasticsearch_protocol  = "http"
default.scpr_logstash.version                 = "1.5.3"
default.scpr_logstash.source_url              = "https://download.elasticsearch.org/logstash/logstash/logstash-1.5.3.tar.gz"
default.scpr_logstash.checksum                = "eb3c366074e561d777348bfe9db3d4d1cccbf2fa8e7406776f500b4ca639c4aa"

default.scpr_logstash.lumberjack_port         = "5960"

default.scpr_logstash.lumberjack_ssl_path     = "/etc"

default.scpr_logstash.kibana                  = false
default.scpr_logstash.kibana_es_server        = node.ipaddress
default.scpr_logstash.kibana_server_name      = "kibana"

default.scpr_logstash.consul = true
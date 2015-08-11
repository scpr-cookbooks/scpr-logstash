include_recipe "kibana_lwrp"

kibana_user "kibana" do
  action  :create
  name    "kibana"
  group   "kibana"
  #home    node.scpr_logstash.kibana_dir
end

kibana_install "kibana" do
  action        :create
  user          "kibana"
  group         "kibana"
  version       node.scpr_logstash.kibana_version
  file_url      node.scpr_logstash.kibana_file_url
  file_type     "tgz"
  file_checksum node.scpr_logstash.kibana_file_checksum
  notifies :restart, "service[kibana]"
end

# -- Write our config file -- #

template "/opt/kibana/kibana.yml" do
  action  :create
  mode    0644
  source  "kibana/kibana.yml.erb"
  variables({
    elasticsearch:  node.scpr_logstash.kibana_es_uri,
    index:          ".kibana",
    port:           node.scpr_logstash.kibana_port,
  })
  notifies :restart, "service[kibana]"
end

# -- Create our upstart service -- #

template "/etc/init/kibana.conf" do
  action  :create
  mode    0644
  source  "kibana/kibana.upstart.erb"
  variables({
    user: "kibana",
    dir:  "/opt/kibana",
  })
  notifies :restart, "service[kibana]"
end

service "kibana" do
  action    [:enable,:start]
  supports  [:enable,:disable,:start,:stop,:restart]
end

# -- Install / Configure nginx -- #

names = node.scpr_logstash.kibana_server_name.split(" ")

if names.length > 1
  server_name     = names[0]
  server_aliases  = names[1..-1]
else
  server_name     = names[0]
  server_aliases  = []
end

kibana_web "kibana" do
  type            'nginx'
  template        'kibana-nginx_file.conf.erb'
  docroot         '/opt/kibana/current'
  listen_port     '80'
  es_server       node.scpr_logstash.kibana_es_uri
  server_name     server_name
  server_aliases  server_aliases
  kibana_port     node.scpr_logstash.kibana_port
end

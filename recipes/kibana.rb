include_recipe "kibana"

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
  file_version  "3.1.2"
  file_url      "https://download.elasticsearch.org/kibana/kibana/kibana-3.1.2.tar.gz"
  file_checksum "480562733c2c941525bfa26326b6fae5faf83109b452a6c4e283a5c37e3086ee"
end

kibana_web "kibana" do
  type        'nginx'
  docroot     '/opt/kibana/current'
  listen_port "80"
end

name             'scpr-logstash'
maintainer       'Eric Richardson'
maintainer_email 'erichardson@scpr.org'
license          'all_rights'
description      'Installs/Configures scpr-logstash'
long_description 'Installs/Configures scpr-logstash'
version          '0.1.17'

depends "apt"
depends "logstash"
depends "elasticsearch"
depends "java"
depends "rabbitmq"
depends "kibana"
#depends "nginx_passenger"
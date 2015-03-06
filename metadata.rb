name             'scpr-logstash'
maintainer       'Eric Richardson'
maintainer_email 'erichardson@scpr.org'
license          'all_rights'
description      'Installs/Configures scpr-logstash'
long_description 'Installs/Configures scpr-logstash'
version          '0.2.0'

depends "apt"
depends "logstash"
depends "scpr-elasticsearch"
depends "java"
depends "kibana"

name             'scpr-logstash'
maintainer       'Eric Richardson'
maintainer_email 'erichardson@scpr.org'
license          'apache2'
description      'Wrapper cookbook for SCPR logstash installs'
long_description 'Wrapper cookbook for SCPR logstash installs'
version          '1.1.1'

depends "apt"
depends "logstash"
depends "scpr-elasticsearch"
depends "scpr-java"
depends "kibana_lwrp"
depends "scpr-consul"
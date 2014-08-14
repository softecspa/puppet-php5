# Class: php5::apache2_mod_php5
#
# Install libapache2-mod-php5
#
# Usage
#   include php5::apache2_mod_php5
#
class php5::apache2_mod_php5 {
  include php5::common

  apt::pin { 'libapache2-mod-php5':
    packages  => 'libapache2-mod-php5',
    version   => $php5::common::php_ensure,
    priority  => '1001'
  } ->
  package{'libapache2-mod-php5':
    ensure  => $php5::common::php_ensure
  }
}

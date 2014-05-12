class php5::fpm::config {

  include php5::fpm::params
  include php5::fpm::logrotate

  File {
    notify  => Service[$php5::fpm::params::service]
  }

  file { $php5::fpm::params::conf_file:
    ensure  => 'present',
    content => template('php5/fpm/etc/php-fpm.conf.erb'),
  }

  #Elimino il pool di default
  file {"${php5::fpm::params::pool_dir}/www.conf" :
    ensure  => absent
  }

}

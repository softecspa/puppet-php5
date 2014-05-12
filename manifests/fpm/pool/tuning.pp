# == Define: php5::fpm::pool::tuning
#
# This define create a new file under /etc/php5/fpm/pool_tuning.d/$name.conf.
# This file'll contain all tuning directives for tuning the pool.
# Directives and values should be passed in the form of a puppet hash.
#
# For tune a pool, a php5::fpm::pool resource must be present in the catalog
#
# === Parameters
#
# [*name*]
#   Must be the name of the pool thath will be tuned
#
# [*params*]
#  puppet hash that contain all tuning directives.
#
# === Examples
#
# 1) create a pool and tune it with following directive configuration:
#   foo   = bar
#   foo2  = bar2
#
#    php5::fpm::pool {"web100":
#      listen_ip   => '127.0.0.1',
#      listen_port => '9000',
#    }
#
#   php5::fpm::pool::tuning {'web100':
#     params => {
#       'foo'   => 'bar',
#       'foo2'  => 'bar2'
#     }
#   }
#
define php5::fpm::pool::tuning (
  $ensure = 'present',
  $params,
) {
  include php5::fpm::params

  if !is_integer($max_children) {
    fail('max_children must be an integer value')
  }
  if (!is_integer($start_server)) and ( $start_server != '') {
    fail('start_server must be an integer value or blank')
  }


  File{
    mode  => '644',
    owner => 'root',
    group => 'root',
    notify  => Service[$php5::fpm::params::service],
  }

  file {"${php5::fpm::params::pool_tuning_dir}/$name.conf":
    ensure  => $ensure,
    content => template('php5/fpm/etc/pool_tuning.conf.erb'),
  }

}

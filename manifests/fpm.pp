class php5::fpm (
  $emergency_restart_threshold = '',
  $emergency_restart_interval  = '',
){
  if !is_integer($emergency_restart_threshold) and ($emergency_restart_threshold != '') {
    fail('emergency_restart_threshold must be integer or blank')
  }

  if ( $emergency_restart_interval !~ /[0-9]+(s|m|h|d)/ ) and ( $emergency_restart_interval != '' ) {
    fail('emergency_restart_threshold must be an integer followed by "s" or "m" or "h" or "d"')
  }

  include php5::common
  include php5::fpm::params
  include php5::fpm::config
  include php5::fpm::service

  apt::pin { 'php5-fpm':
    packages  => 'php5-fpm',
    version   => $php5::common::php_ensure,
    priority  => '1001'
  } ->
  package{'php5-fpm':
    ensure  => $php5::common::php_ensure
  }

  Class['php5::common'] ->
  Package['php5-fpm'] ->
  Class['php5::fpm::config'] ->
  Class['php5::fpm::service']
}

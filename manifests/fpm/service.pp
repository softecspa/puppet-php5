class php5::fpm::service {

  include php5::fpm::params

  service { $php5::fpm::params::service:
    ensure    => running,
    enable    => true,
    hasstatus => true
  }

  # monitor main php-fpm process
  nrpe::check_procs { 'php-fpm-master-process':
    crit             => '1:1',
    metric           => 'PROCS',
    argument_array   => 'php-fpm: master process',
    procs_owner      => 'root',
  }
}

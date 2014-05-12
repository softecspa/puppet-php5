class php5::fpm::params {

  $service = $operatingsystem ? {
    /(?i-mx:ubuntu|debian)/ => 'php5-fpm',
  }

  $confdir = $operatingsystem ? {
    /(?i-mx:ubuntu|debian)/ => '/etc/php5/fpm',
  }

  $conf_file = $operatingsystem ? {
    /(?i-mx:ubuntu|debian)/ => "$confdir/php-fpm.conf",
  }

  $pool_dir = $operatingsystem ? {
    /(?i-mx:ubuntu|debian)/ => "$confdir/pool.d",
  }

  $pool_tuning_dir = $operatingsystem ? {
    /(?i-mx:ubuntu|debian)/ => "$confdir/pool_tuning.d",
  }

  $logdir = '/var/log/php-fpm'
}

class php5::cli {

  include php5::common

  apt_puppetlabs::pin {'php5-cli':
    packages  => 'php5-cli',
    version   => $php5::common::php_ensure,
    priority  => '1001'
  } ->
  package{'php5-cli':
    ensure  => $php5::common::php_ensure
  }
}

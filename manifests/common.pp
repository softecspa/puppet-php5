class php5::common {

  # installa php5.4 per versioni > 10.04
  $php54 = "5.4.22-1+debphp.org~${lsbdistcodename}+1"

  $php_ensure = $lsbdistcodename? {
    'hardy' => 'present',
    default => $php54
  }

  include php5::common::install
  include php5::common::config

  Class['php5::common::install'] ->
  Class['php5::common::config']
}

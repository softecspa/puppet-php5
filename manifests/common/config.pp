class php5::common::config {

  $phpcusttemplate1 = "php-softec.ini"
  $phpdir = "/etc/php5"

  # configurazioni aggiuntive custom per il php (globale)
  file { "${phpdir}/conf.d/${phpcusttemplate1}":
    ensure          => present,
    mode            => 644,
    owner           => root,
    group           => root,
    content         => template("php5/${phpcusttemplate1}"),
    notify          => Exec['php5-apache2-graceful'],
  }

  exec {'php5-apache2-graceful':
    command     => '/usr/sbin/apache2ctl graceful',
    onlyif      => '/usr/bin/test -e /etc/init.d/apache2',
    refreshonly => true
  }
}

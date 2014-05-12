class php5::ioncube (
  $download_url = 'http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.bz2',
  $version      = '5.4'
) {

  if $::lsbdistrelease < 10 {
    fail('php5::ioncube is available only for ubuntu 10.04 and newer')
  }

  exec {'download ioncube':
    command => "/usr/bin/wget \"${download_url}\" -O /usr/local/src/ioncube.tar.bz2",
    creates => '/usr/local/src/ioncube.tar.bz2'
  }

  $so_path = $::architecture? {
    'i386'  => '/usr/lib/php5/20100525+lfs/',
    default => '/usr/lib/php5/20100525/'
  }

  exec {'extract ioncube':
    command => "/bin/tar -jxf /usr/local/src/ioncube.tar.bz2 -C ${so_path}",
    creates => "${so_path}/ioncube",
    require => Exec['download ioncube']
  }

  file {'/etc/php5/mods-available/01-ioncube.ini':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0664',
    content => "zend_extension=${so_path}ioncube/ioncube_loader_lin_${version}.so",
    notify  => Exec['apache2-graceful'],
    require => Exec['extract ioncube']
  }

  file {'/etc/php5/conf.d/01-ioncube.ini':
    ensure  => link,
    target  => '/etc/php5/mods-available/01-ioncube.ini',
    require => File['/etc/php5/mods-available/01-ioncube.ini']
  }

}

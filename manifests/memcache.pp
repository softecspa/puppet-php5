class php5::memcache {

  php5::module {'memcache':
    ensure  => 'UNSET',
  }

  $inifile = $lsbdistcodename ? {
    'hardy'   => '/etc/php5/conf.d/memcache.ini',
    default   => '/etc/php5/mods-available/memcache.ini',
  }

  file { $inifile :
    ensure  => present,
    owner => root,
    group => root,
    mode  => 644,
    source  =>  [ "puppet:///modules/php5/memcache/$cluster/memcache.ini",
                  "puppet:///modules/php5/memcache/default/memcache.ini", ],
    notify  => Service['apache2'],
    require => Php5::Module['memcache']
  }

  file {'/etc/apache2/conf.d/php-sessions-memcache':
    ensure  => absent,
    owner   => 'root',
    group   => 'root',
    mode    => '644',
    source  => "puppet:///modules/php5/apache2/php-sessions-memcache",
    require => [ Package['apache2'], Php5::Module['memcache'] ]
  }

  file { "/var/lib/memcache":
    ensure  => directory,
    owner => root,
    group => root,
    mode  => 755,
    require => Php5::Module['memcache']
  }

}

# Class: php5::xhprof
#
# Usage:
# include php5::xhprof

class php5::xhprof {

  include php5::common

	$tmpdir = "/tmp/xhprof"
	$phpinfo_cli = "echo '<?php phpinfo(); ?>' | php -i"

  #file { $tmpdir:
  #  ensure  => directory,
  #  owner   => 'root',
  #  group   => 'root',
  #  mode    => 755
  #}

  git::clone{'xhprof':
    url     => 'https://github.com/facebook/xhprof.git',
    path    => $tmpdir,
  }

  exec {'xhprof-installation':
    cwd     => '/tmp/xhprof/extension',
    command => '/usr/bin/phpize && ./configure && /usr/bin/make && /usr/bin/make install',
    unless  => "${phpinfo_cli} | grep '^xhprof$'",
    require => Git::Clone['xhprof'],
  }

  file { "${php5::common::config::phpdir}/conf.d/xhprof.ini":
    ensure  => present,
    mode    => 644,
    owner   => root,
    group   => root,
    source  => "puppet:///modules/php5/xhprof.ini",
    require	=> Exec["xhprof-installation"],
  }

  exec { "xhprof-apache2-reload":
    command		=> "/etc/init.d/apache2 force-reload",
    subscribe	=> File["${php5::common::config::phpdir}/conf.d/xhprof.ini"],
    refreshonly	=> true,
  }
}

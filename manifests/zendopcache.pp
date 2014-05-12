# == Class: php5::zendopcache
#
# This class manage installation and configuration of Zend OpCache php extension through PECL.
# It manage configuration under /etc/php5/mods-available/zendopcache.ini.
# Option not managed in this class can be added using php5::zendopcache::option define
#
# === Parameters
#
# [*ensure*]
#   If present, enable zend opcache extension. Default: present
#
# [*version*]
#   Module version to install. If it's not specified, last version'll be installed.
#
# [*memory_consumption*]
#   The size of the shared memory storage used by OPcache, in megabytes. Default: 128
#
# [*interned_strings_buffer*]
#   The amount of memory used to store interned strings, in megabytes. Default: 8
#
# [*max_accelerated_files*]
#   The maximum number of keys (and therefore scripts) in the OPcache hash table. Default: 4000
#
# [*revalidate_freq*]
#  How often to check script timestamps for updates, in seconds. 0 will result in OPcache checking for updates on every request. Default: 60
#
# [*fast_shutdown*]
#  If 1, enable opcache.fast_shutdown directive. Default: 1
#
# [*enable_cli*]
#  Enables the opcode cache for the CLI version of PHP. Default: 1
#
# === Examples
#
# 1) Install and enable latest zendopcache version
#   include php5::zendopcache
#
# 2) Install 7.0.2 version and disable cache for CLI.
#
#    class {'php5::zendopcache':
#      version    => '7.0.2',
#      enable_cli => '0',
#    }
#
class php5::zendopcache (
  $ensure                   = present,
  $version                  = '',
  $memory_consumption       = '128',
  $interned_strings_buffer  = '8',
  $max_accelerated_files    = '4000',
  $revalidate_freq          = '60',
  $fast_shutdown            = '1',
  $enable_cli               = '1',
) {

  include php5::common

  $packagename = $version ? {
    ''      => 'zendopcache',
    default => "zendopcache-${version}"
  }

  if (! is_integer($memory_consumption) and $memory_consumption != '' ) {
    fail ('memory_consumption must be an integer value or blank')
  }

  if (! is_integer($interned_strings_buffer) and $interned_strings_buffer != '' ) {
    fail ('interned_strings_buffer must be an integer value or blank')
  }

  if (! is_integer($max_accelerated_files) and $max_accelerated_files != '' ) {
    fail ('max_accelerated_files must be an integer value or blank')
  }

  if (! is_integer($revalidate_freq) and $revalidate_freq != '' ) {
    fail ('revalidate_freq must be an integer value or blank')
  }

  if ( $fast_shutdown != '1' and $fast_shutdown != '0' and $fast_shutdown != '') {
    fail ('fast_shutdown must be 1 or 0 or blank')
  }

  if ( $enable_cli != '1' and $enable_cli != '0' and $enable_cli != '') {
    fail ('enable_cli must be 1 or 0 or blank')
  }

  pecl::pecl_module_install {$packagename :}

  if defined(Class['php5::fpm']) {
    $notified_service = Service[$php5::fpm::params::service]
  } else {
    if defined(Class['php5::apache2_mod_php5']) {
      $notified_service = Service['apache2']
    } else {
      $notified_service = undef
    }
  }

  concat_build { 'zendopcache':
    order         => ['*.tmp'],
    target        => "${php5::common::config::phpdir}/mods-available/zendopcache.ini",
    notify        => $notified_service,
  }

  concat_fragment { "zendopcache+001.tmp":
    content => template('php5/modules/zendopcache.ini.erb')
  }

  $ensure_conf_file = $ensure ? {
    present => 'link',
    default => 'absent',
  }

  file { "${php5::common::config::phpdir}/conf.d/10-zendopcache.ini":
    ensure  => $ensure_conf_file,
    target  => "${php5::common::config::phpdir}/mods-available/zendopcache.ini",
    require => Concat_build['zendopcache']
  }

}

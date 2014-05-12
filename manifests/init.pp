# == Class: php5
# This module manage php5 and its components. You can install independently php5-cli, php5-fpm and apache2_mod_php5.
#
# === Parameters
#
# [*php5_cli*]
#   Default: true. if true, install php5-cli package.
#
# [*php5-fpm*]
#   Default: false. If true install php5-fpm package and configure php5-fpm up&running
#
# [*apache2_mod_php5*]
#   Default: false. If true install apache2-mod-php5 package.
#
# === Examples
#
# 1) install only php5-cli
#
# include php5
#
# 2) Install only php5-cli and php5-fpm
#
# class {"php5":
#   php5_cli  => true
#   php5_fpm  => true,
# }
#
class php5 (
  $php5_cli         = true,
  $php5_fpm         = false,
  $apache2_mod_php5 = false,
) {

  if ( $php5_cli or $php5_fpm or $apache2_mod_php5 ) {

    include php5::common

    if $php5_cli {
      include php5::cli
      Class['php5::common'] -> Class ['php5::cli']
    }
    if ($php5_fpm) {
      include php5::fpm
      Class['php5::common'] -> Class ['php5::fpm']
    }
    if ($apache2_mod_php5) {
      include php5::apache2_mod_php5
      Class['php5::common'] -> Class ['php5::apache2_mod_php5']
    }
  }

  else {
    fail ('please specify at least one php5 version (php5_cli, php5_fpm, apache2_mod_php5')
  }
}

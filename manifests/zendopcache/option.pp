# == Define: php5::zendopcache::option
#
# This define add options to zendopcache module configuration
#
# === Parameters
#
# [*key*]
#   Name of directive without opcache prefix. Ex: max_wasted_percentage. If none is specified $name will be used
#
# [*value*]
#   Value to use for this option
#
# [*order*]
#   Order to assgn to option in configuration file. Default: 0
#
# === Examples
#
# Add opcache.max_wasted_percentage and set to 10
#
#   php5::zendopcache::option {'max_wasted_percentage':
#     value => '10',
#   }
#
define php5::zendopcache::option (
  $key    = '',
  $value,
  $order  = 0,
){

  $keyname = $key ? {
    ''      => $name,
    default => $key,
  }

  if ! is_integer($order) {
    fail('order must be an integer value')
  }

  concat_fragment { "zendopcache+005-$order-${name}.tmp":
    content => "opcache.${keyname}=${value}"
  }
}

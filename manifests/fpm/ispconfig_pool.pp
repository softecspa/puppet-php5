# == Define: php5::fpm::ipsconfig_pool
#
# This define is a wrapper of php5::fpm::pool define. It creates a pool with our ispconfig VH standard, user and group to manage this pool.
# No mandatory params but name of resource must be the id of the pool
#
# === Parameters
#
# [*domain*]
#   Domanin name of the virtualhost served by the pool
#
# [*memory_limit*]
#   php5 memory_limit parameter
#
# [*max_children*]
#   max number of php-fpm children. From this value will be calculated min_spare, max_spare e min children
#
# === Examples
#
# 1) Create a pool for virtualhost example.com managed by ispconfig on web100. Define will create web100 user and group with needed dependencies.
#
# php5::fpm::ispconfig_pool {'100': }
#
define php5::fpm::ispconfig_pool (
  $domain       = '',
  $memory_limit = '',
  $max_children = '10',
  $monitoring   = true,
  $nagios       = '',
) {

  $pool_id=$name
  $start_port='9000'
  $start_uid='10000'

  $listen_port=inline_template('<%= start_port.to_i + pool_id.to_i -%>')
  $uid=inline_template('<%= start_uid.to_i + pool_id.to_i -%>')
  $gid=inline_template('<%= start_uid.to_i + pool_id.to_i -%>')

  $pool_name="web${pool_id}"

  if !is_integer($pool_id) {
    fail('name must be an integer value')
  }

  $nagios_hostname = $nagios ? {
    ''      => 'tiglio',
    default => $nagios
  }

  user {$pool_name:
    comment => "php-fpm ${pool_name} user",
    gid     => $pool_name,
    uid     => $uid,
    require => Group[$pool_name],
  }
  group {$pool_name:
    ensure  => 'present',
    gid     => $gid,
  }
  php5::fpm::pool {$pool_name:
    user                => $pool_name,
    group               => $pool_name,
    listen_ip           => $ipaddress_eth1,
    listen_port         => $listen_port,
    max_children        => $max_children,
    memory_limit        => $memory_limit,
    pool_domain         => $domain,
    monitoring          => $monitoring,
    nagios_hostname     => $nagios_hostname,
    monitoring_domain   => 'asp.softecspa.it',
  }
}

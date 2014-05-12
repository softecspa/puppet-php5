# == Define: php5::fpm::pool
#
# This define creates new php5-fpm pool.
# If you specify custom user and/or group, this user and grop must be managed by puppet outside the module.
# This defines assumes that php5::fpm class is included in the host's catalog.
#
# Define creates a configuration file under /etc/php5/fpm/pool.d/$name.conf
#
# === Parameters
#
# [*pm*]
#   How process manager control number of children. It can be dynamic|static|ondemand. Default: dynamic
#
# [*pool_domain*]
#   Domain name for the served application. Optionally, must be in xxxx.yy form
#
# [*max_requests*]
#   max number of requests served by a child. Default: 10000
#
# [*status_path*]
#   URI for mionitoring pool. Default: /fpm-status
#
# [*user*]
#   user that run pool. Default www-data
#
# [*group*]
#  group that run pool. Default www-data
#
# [*listen_ip*]
#  IP address over which pool listen for incoming requests. Default: 127.0.0.1
#
# [*listen_port*]
#  TCP port over which pool listen for incoming requests.
#
# [*socket*]
#  Socket absolute path. If you want to use socket insted of TCP port. Default ''
#
# [*max_children*]
#  max_children php-fpm parameter. Mandatory. Default: 10
#
# [*min_spare_servers*]
#  min_spare_servers php-fpm parameter. If not specified it'll be: 20% of max_children
#
# [*max_spare_servers*]
#  max_spare_servers php-fpm parameter. If not specified it'll be: 60% of max_children
#
# [*start_servers*]
#  start_servers php-fpm parameter. If it's not specified it'll be: min_spare_servers + (max_spare_servers - min_spare_servers) / 2
#
# [*process_idle_timeout*]
#  process_idle_timeout php-fpm parameter. It must be followed by 's' suffix. Default: 10s
#
# [*access_format*]
#   Access log format. Default: %R - %u %t \"%m %r%Q%q\" %s %f %{mili}d %{kilo}M %C%% \"%{Cache-Control}o\" \"%{HTTP_X_FORWARDED_FOR}e\"
#
# [*max_execution_time*]
#   max_execution_time php parameter. Default: 60s
#
# [*request_terminate_timeout*]
#   The timeout for serving a single request after which the worker process will be killed. Default: max_execution_time + 10s
#
# [*access_log*]
#  access_log php-fpm parameter. By default it'll be /var/log/php-fpm/$name_access.log.
#  If you want to disable access_log this parameter should be set to false
#
# [*error_log*]
#  set php_admin_value[error_log] parameter. By default it'll be /var/log/php-fpm/$name_error.log.
#  If you want to disable error_log this parameter should be set to false
#
# [*request_slowlog_timeout*]
#  request_slowlog_timeout php-fpm parameter. This parameter decided threshold over that requests will be logged in slow_log file.
#  Available value can be an integer followed by suffix 's' or 0 (disabled). By default: 10s
#
# [*slow_log*]
#  slow_log php-fpm parameter. If request_slowlog_timeout is different from 0, slow requests will be logged in this file.
#  By default logfile will be: /var/log/php-fpm/web300_slow.log. To disable slowlog (though request_slowlog_timeout is different from 0) set this parameter to false.
#
#  [*sendmail_path*]
#   sendmail_path php5 parameter. By default is combines global variable $global_sendmail_path containing executable path and $pool_domain. Default $global_sendmail_path -t -i -f no-reply@$pool_domain
#
#  [*memory_limit*]
#   memory_limit php5 parameter.
#
#  [*tuning*]
#   If this parameter is set, this define will call php5::fpm::pool::tuning define. Please refer to php5::fpm::pool::tuning documentation.
#
#  [*monitoring*]
#   If this parameter is set to true, it enables monitoring of pool. A php5::fpm::monitoring and nagios::check resources are exported. Default is false
#
#  [*nagios_hostname*]
#   Used as suffix for tag used to tag nagios::check resource that can be imported by a nagios server. Checks are exported with tag: nagios_check_phpfpm_$nagios_hostname
#
#  [*monitoring_domain*]
#   Domain used for monitoring pourpose. If monitoring is set to true, a VirtualHost named $poolname.$hostname.$monitoring_domain will be exported. This VH is used only for monitoring pourpose
#
# === Examples
#
# 1) install a new pool named web100 that listen on 127.0.0.1:9000 with default values for all other params.
#
#    php5::fpm::pool {"web100":
#      listen_ip   => '127.0.0.1',
#      listen_port => '9000',
#    }
#2) Install a new pool named web100 that listen on socket /tmp/web100.sock and use customized user group
#
#    user {'web100':
#      ensure  => 'present',
#      uid     => $specific_uid
#    }
#
#    group {'web100':
#      ensure  => 'prensent',
#      gid     => $specific_uid
#    }
#
#    php5::fpm::pool {'web100':
#      socket  => '/tmp/web100.sock',
#      user    => 'web100',
#      group   => 'web100'
#    }
#
#3) Install a new pool named web100 that listen on 127.0.0.1:9000 with customized max_children set to 100
#
#    php5::fpm::pool {'web100':
#      listen        => '127.0.0.1',
#      port          => '9000',
#      max_children  => '100'
#    }
#    in this example the others tuning directive will be:
#      min_spare_servers = 20% max_children = 20
#      max_spare_servers = 60% max_children = 60
#      start_servers     = min_spare_servers + (max_spare_servers - min_spare_servers) / 2 = 40
#
#4) Install a new pool named web100 with customized access_log path and error_log disabled
#
#    php5::fpm::pool {'web100':
#      listen        => '127.0.0.1',
#      port          => '9000',
#      max_children  => '100',
#      access_log    => '/var/log/custompath/web100.log',
#      error_log     => false
#    }
#5) Install a new pool named web100 and monitored through a virtualhost named web100.$hostname.asp.softecspa.it. We use instead "tiglio" for tag nagios::check resource that will be imported by nagios server
#   php5::fpm::pool {'web100':
#     listen_ip         => '127.0.0.1',
#     listen_port       => '9000',
#     monitoring        => true,
#     nagios_hostname   => 'tiglio',
#     monitoring_domain => 'asp.softecspa.it'
#   }
#
#   Import resource that creates a VirtualHost used for monitor fpm-status page. They can be imported also in another server
#
#   node xxxx {
#     Php5::Fpm::Monitoring <<| tag == 'php-fpm-monitor' |>> {
#       monitor_domain  => "asp.softecspa.it"
#     }
#   }
#
#   Import resources nagios::check on nagios host. This resources creates a nagios_service resource, this services will be monitored on VIP_clusterarticolo nagios_host
#
#   node nagiosserver {
#     Nagios::Check <<| tag == 'nagios_check_phpfpm_tiglio' |>> {
#       host  => 'VIP_clusterarticolo'
#     }
#   }
#
define php5::fpm::pool (
  $ensure                     = 'present',
  $pm                         = 'dynamic',
  $pool_domain                = '',
  $user                       = 'www-data',
  $group                      = 'www-data',
  $listen_ip                  = '127.0.0.1',
  $listen_port                = '',
  $socket                     = '',
  $max_children               = '10',
  $start_servers              = '',
  $min_spare_servers          = '',
  $max_spare_servers          = '',
  $max_requests               = '10000',
  $status_path                = '/fpm-status',
  $process_idle_timeout       = '10s',
  $access_log                 = '',
  $access_format              = '%R - %u %t \"%m %r%Q%q\" %s %f %{mili}d %{kilo}M %C%% \"%{Cache-Control}o\" \"%{HTTP_X_FORWARDED_FOR}e\"',
  $error_log                  = '',
  $slow_log                   = '',
  $request_slowlog_timeout    = '10s',
  $request_terminate_timeout  = '',
  $max_execution_time         = '60',
  $sendmail_path              = '',
  $memory_limit               = '',
  $tuning                     = '',
  $monitoring                 = false,
  $nagios_hostname            = '',
  $monitoring_domain          = '',
) {

  include php5::fpm::params

  if $name == 'www' {
    fail('Nane www not allowed')
  }

  if ($pm != 'dynamic') and ($pm != 'ondemand') and ($pm != 'static') {
    fail ('pm parameter: allowed value are dynamic|ondemand|static')
  }

  if $user != 'www-data' {
    User[$user] -> Php5::Fpm::Pool[$name]
  }

  if !defined(Class['php5::fpm']) {
    fail('To define a php5::fpm::pool you need to include php5 class whith php5_fpm parameter set to true or include directly php5::fpm class')
  }

  if !is_integer($max_children) {
    fail('max_children must be an integer value')
  }

  if !is_integer($max_requests) and ($max_requests != '') {
    fail('max_requests must be an integer value')
  }

  if (!is_integer($min_spare_servers)) and ( $min_spare_servers != '') {
    fail('min_spare_servers must be an integer value or blank')
  }

  if (!is_integer($max_spare_servers)) and ( $max_spare_servers != '') {
    fail('max_spare_servers must be an integer value or blank')
  }

  if (!is_integer($start_servers)) and ( $start_servers != '') {
    fail('start_servers must be an integer value or blank')
  }

  if $process_idle_timeout !~ /[0-9]+s/ {
    fail('process_idle_timeout must be an integer followed by "s"')
  }

  if ($memory_limit !~ /[0-9]+M/) and ($memory_limit != '') {
    fail('memory_limit should be an integer followed by "M" suffix')
  }

  if ($access_log != false) and ($access_log != '') {
    validate_absolute_path($access_log)
  }

  if ($error_log != false) and ($error_log != '') {
    validate_absolute_path($error_log)
  }

  if ($slow_log != false) and ($slow_log != '') {
    validate_absolute_path($slow_log)
  }

  if ($request_slowlog_timeout !~ /[0-9]+s/) and ($request_slowlog_timeout != '0') {
    fail('request_slowlog_timeout must be an integer followed by "s" or 0 to disable slowlog')
  }

  if ($request_slowlog_timeout != '0') and ($slow_log == false) {
    fail("if request_slowlog_timeout is not 0 (disabled), slow_log can't be false")
  }

  if (! is_integer($max_execution_time) and $max_execution_time != '') {
    fail ('max_execution_time must be an integer value')
  }

  if $socket =='' {
    #TODO: da capire perche' non va con is_integer
    #if ($listen_ip == '') or (!is_integer($listen_port)) {
    if ($listen_ip == '') or ($listen_port == '') {
      fail('Please specify listen_ip and listen_port or a socket')
    }
  }
  else {
    if (($listen_ip != '127.0.0.1') and ($listen_ip != '') ) or ($listen_port != '') {
      fail('listen on socket and TCP port cannot be used at the same time')
    }
  }

  if ($user != 'www-data') and (!defined(User[$user])) {
    fail("User $user must be present in the catalog")
  }

  if ($group != 'www-data') and (!defined(Group[$group])) {
    fail("Grup $group must be present in the catalog")
  }

  $min_spare = $min_spare_servers ? {
    ''      => inline_template('<%= max_children.to_i*20/100 -%>'),
    default => $min_spare_servers
  }

  $max_spare = $max_spare_servers ? {
    ''      => inline_template('<%= max_children.to_i*60/100 -%>'),
    default => $max_spare_servers
  }

  $start = $start_servers ? {
    ''      => inline_template('<%=  min_spare.to_i + (max_spare.to_i - min_spare.to_i) / 2 -%>'),
    default => $start_servers
  }

  $real_access_log = $access_log ? {
    ''      => "${php5::fpm::params::logdir}/${name}_access.log",
    default => $access_log
  }

  $real_error_log = $error_log ? {
    ''      => "${php5::fpm::params::logdir}/${name}_error.log",
    default => $error_log
  }

  $real_slow_log = $slow_log ? {
    ''      => "${php5::fpm::params::logdir}/${name}_slow.log",
    default => $slow_log
  }

  $real_request_terminate_timeout = $request_terminate_timeout ? {
    ''  => $max_execution_time ? {
      ''  => '',
      default => inline_template('<%= max_execution_time.to_i + 10 -%>'),
    },
    default => $request_terminate_timeout
  }

  $real_sendmail_path = $sendmail_path ? {
    ''      => $pool_domain ? {
      ''      => '',
      default => "${global_sendmail_path} -t -i -f no-reply@${pool_domain}",
    },
    default => $sendmail_path
  }

  if $monitoring {

    @@php5::fpm::monitoring { "${name}.${hostname}" :
      ensure          => $ensure,
      fpm_listen_ip   => $listen_ip,
      fpm_listen_port => $listen_port,
      fpm_status_path => $status_path,
      fpm_socket      => $socket,
      tag             => 'php-fpm-monitor'
    }

    @@nagios::check {"php_fpm_status_${name}_${hostname}":
      ensure                => $ensure,
      checkname             => 'check_php_fpm_status',
      plugin                => true,
      plugin_source         => 'puppet:///modules/php5/nagios/check_php_fpm_status',
      plugin_config         => true,
      plugin_config_source  => 'puppet:///modules/php5/nagios/check_php_fpm_status.cfg',
      service_description   => "${name} su ${hostname}",
      params                => "!'${name}.${hostname}.${monitoring_domain}'!80!2,1!1,2!$nagios_user!$nagios_pw",
      target                => "php_fpm_pool_${::hostname}.cfg",
      tag                   => "nagios_check_phpfpm_$nagios_hostname",
    }
  }

  if(!defined(File[$php5::fpm::params::logdir])) {
    file {$php5::fpm::params::logdir :
      ensure  => 'directory',
      mode    => '0755',
      owner   => root,
      group   => 'super',
      require => Group['super']
    }
  }

  File {
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    notify  => Service[$php5::fpm::params::service],
    require => Package['php5-fpm'],
  }

  $listen = $socket ? {
    ''      => "${listen_ip}:${listen_port}",
    default => $socket
  }

  #Crea il file di log con i giusti permessi, altrimenti sarebbe illegibile dal gruppo users fino alla prima rotazione dei log.
  if $real_access_log != false {
    file { $real_access_log:
      ensure  => present,
      mode    => 640,
      owner   => 'root',
      group   => 'users',
      before  => File["${php5::fpm::params::pool_dir}/$name.conf"],
    }
  }

  if $real_error_log != false {
    file { $real_error_log:
      ensure  => present,
      mode    => 640,
      owner   => 'root',
      group   => 'users',
      before  => File["${php5::fpm::params::pool_dir}/$name.conf"],
    }
  }

  if $real_slow_log != false {
    file { $real_slow_log:
      ensure  => present,
      mode    => 640,
      owner   => 'root',
      group   => 'users',
      before  => File["${php5::fpm::params::pool_dir}/$name.conf"],
    }
  }

  file {"${php5::fpm::params::pool_dir}/$name.conf":
    ensure  => $ensure,
    content => template('php5/fpm/etc/pool.conf.erb')
  }

  if !defined(File[$php5::fpm::params::pool_tuning_dir]) {
    file {$php5::fpm::params::pool_tuning_dir:
      ensure  => directory,
      mode    => '0755',
      owner   => 'root',
      group   => 'root',
    }
  }

  if $tuning != '' {
    php5::fpm::pool::tuning{$name:
      ensure  => $ensure,
      params  => $tuning,
    }
  }

}

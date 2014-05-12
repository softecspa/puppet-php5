define php5::fpm::monitoring (
  $ensure           = 'present',
  $fpm_listen_ip,
  $fpm_listen_port  = '',
  $fpm_status_path,
  $fpm_socket       = '',
  $monitor_domain   = '',
) {

  $listen = $fpm_socket ? {
    ''      => "-host ${fpm_listen_ip}:${fpm_listen_port}",
    default => "-socket $fpm_socket",
  }

  apache2::vhost {"${name}":
    ensure        => $ensure,
    server_name   => "${name}.${monitor_domain}",
    listen_port   => $www_port,
    document_root => '/var/www/sharedip',
    template      => 'apache2/vhost/vhost_fpm_monitor_header.erb',
    tag           => 'php-fpm-monitor',
  }

}

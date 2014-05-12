class php5::uploadprogress {

  pecl::pecl_module_install{'uploadprogress': }

  if $lsbdistcodename != 'hardy' {
    file { "/etc/php5/conf.d/uploadprogress.ini":
      ensure  => present,
      owner => root,
      group => root,
      mode  => 644,
      source  => "puppet:///modules/php5/uploadprogress.ini",
      require => Pecl::Pecl_module_install['uploadprogress'],
      notify  => Service['apache2']
    }
  }
}

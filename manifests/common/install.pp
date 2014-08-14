class php5::common::install {

  if $php5::common::php_ensure =~ /5.4.*/ {
    if !defined(Softec_apt::Ppa['ondrej/php5-oldstable']) {
      softec_apt::ppa { 'ondrej/php5-oldstable':
        mirror  => true,
        key     => 'E5267A6C'
      }
    }

    if !defined(Apt::Pin['php5-common']) {
      apt::pin {'php5-common':
        packages  =>'php5-common',
        version   => $php5::common::php_ensure,
        priority  => '1001',
        require   => Softec_apt::Ppa['ondrej/php5-oldstable']
      }
    }

    $php_require = [ Softec_apt::Ppa['ondrej/php5-oldstable'], Apt::Pin['php5-common'] ]
  }
  else {
    $php_require = undef
  }
}

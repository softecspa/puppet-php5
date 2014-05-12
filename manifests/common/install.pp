class php5::common::install {

  if $php5::common::php_ensure =~ /5.4.*/ {
    if !defined(Apt::Ppa['ondrej/php5-oldstable']) {
      apt::ppa { 'ondrej/php5-oldstable':
        key => 'E5267A6C',
        mirror => true
      }
    }

    if !defined(Apt::Pin['php5-common']) {
      apt::pin {'php5-common':
        version => $php5::common::php_ensure,
        require => Apt::Ppa['ondrej/php5-oldstable']
      }
    }
    
    $php_require = [ Apt::Ppa['ondrej/php5-oldstable'], Apt::Pin['php5'] ]
  }
  else {
    $php_require = undef
  }
}

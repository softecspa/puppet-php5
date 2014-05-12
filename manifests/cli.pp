class php5::cli {

  include php5::common

  apt::pin {
    'php5-cli': version => $php5::common::php_ensure;
  } ->
  package{'php5-cli':
    ensure  => $php5::common::php_ensure
  }
}

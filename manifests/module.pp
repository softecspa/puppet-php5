# == php5::module
#
# Installs php5 modules
#
# Ensure package $name is present and enable the
# corresponding module
#
# == Params
#
# [*ensure*]
#   ensure can be one of:
#     [UNSET, present] --> assure the package is installed (Default)
#     pin --> assure the package is installed using the version specified in php5 module
#     absent --> package should be removed
# [*modulename*]
#    Control package name, if set used as package name, else it's autogenerated (Default: false)
#
# === Sample usage
#
#   php5::module { "curl": ensure => "present"; }
#
define php5::module($ensure='UNSET', $modulename=false) {

  $real_name = $modulename ? {
    false => "php5-${name}",
    default => $modulename
  }

  if $ensure in [ 'UNSET', 'present' ] {
    $ensure_real = 'present'
  } elsif $ensure == 'pin' {
    $ensure_real = $php5::common::php_ensure
    if !defined(Apt_puppetlabs::Pin[$real_name]) {
      apt_puppetlabs::pin{$real_name :
        packages  => $real_name,
        version   => $php5::common::php_ensure,
        priority  => '1001'
      }
    }
  } elsif $ensure == 'absent' {
    $ensure_real = 'absent'
  } else {
    fail "${ensure} is not valid!"
  }

  package { $real_name:
    ensure => $ensure_real,
  }
}

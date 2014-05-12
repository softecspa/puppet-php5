class php5::fpm::logrotate {

  include php5::fpm::params

  logrotate::file { 'php5-fpm-pool':
    log           =>  "${php5::fpm::params::logdir}/*.log /var/log/php5-fpm.log",
    interval      =>  'daily',
    rotation      =>  '930',
    options       =>  [ 'missingok', 'compress', 'notifempty', 'sharedscripts' ],
    archive       =>  true,
    olddir        =>  "${php5::fpm::params::logdir}/archives",
    olddir_owner  =>  'root',
    olddir_group  =>  'users',
    olddir_mode   =>  '655',
    create        =>  '640 root users',
    postrotate    =>  'invoke-rc.d php5-fpm reload',
  }

  # elimina la rotazione creata dal pacchetto che contempla i pool
  file {'/etc/logrotate.d/php5-fpm':
    ensure  => absent,
  }

}

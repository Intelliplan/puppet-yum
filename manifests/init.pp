class yum(
  $installpath     = '/var/yum/el6/x86_64',
  $install_server  = true,
  $server_name     = 'yum.bit',
  $port            = 80,
  $user            = 'yum'
) {

  anchor { 'yum::start': }

  package { 'rpm-build':
    ensure  => present,
    require => Anchor['yum::start'],
    before  => Anchor['yum::end'],
  }

  class { 'yum::directories':
    require => Anchor['yum::start'],
    before  => Anchor['yum::end'],
  }

  if $install_server {
    class { 'yum::server':
      require => [
        Anchor['yum::start'],
        Class['yum::directories'],
      ],
      before => Anchor['yum::end'],
    }
  }

  anchor { 'yum::end': }
}
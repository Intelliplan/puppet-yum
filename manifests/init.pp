class yum(
  $installpath     = '/var/yum/el6/x86_64',
  $install_server  = true,
  $server_name     = $::fqdn,
  $port            = 80,
  $user            = 'yum',
  $deploy_group    = 'yummod'
) {
  group { $deploy_group:
    ensure  => present,
    system  => true,
  }

  package { 'rpm-build':
    ensure  => present,
  }

  contain 'yum::directories'

  if $install_server {
    class { 'yum::server':
      require => Class['yum::directories'],
    }
    contain 'yum::server'
  }
}

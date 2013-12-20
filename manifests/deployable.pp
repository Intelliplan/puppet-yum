define yum::deployable(
  $folder = $name,
  $deploy_user,
  $deploy_user_pub_key,
  $deploy_group,
) {
  user { $deploy_user:
    ensure => present,
    home   => $folder,
    system => true,
    gid    => $deploy_group,
  }

  # ssh key for the upload user
  file { "$folder/.ssh":
    ensure => directory,
    mode   => '700',
    owner  => $deploy_user,
  }

  # for uploads to the yum repository
  ssh_authorized_key { $deploy_user:
    user    => $deploy_user,
    ensure  => present,
    type    => 'ssh-rsa',
    key     => $deploy_user_pub_key,
    require => [
      User[$deploy_user],
      File["$folder/.ssh"]
    ],
  }
}
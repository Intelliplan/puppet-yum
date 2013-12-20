class yum::directories {
  $installpath = $yum::installpath

  # http://sbr600blog.blogspot.se/2012/03/how-to-create-repository-release-rpm.html
  # http://tuxers.com/main/settingup-a-local-private-yum-repository-lpyr-on-centos-part1/
  # http://tuxers.com/main/setting-up-a-local-private-yum-repository-lpyr-on-centos-part2-2/
  # http://www.linuxtopia.org/online_books/rhel6/rhel_6_deployment/rhel_6_deployment_sec-Creating_a_Yum_Repository.html
  # http://www.techrepublic.com/blog/linux-and-open-source/create-your-own-yum-repository/
  # https://access.redhat.com/site/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Deployment_Guide/sec-Configuring_Yum_and_Yum_Repositories.html

  package { 'createrepo':
    ensure => latest,
  }

  $install_dir_parents = dir_parents($installpath)

  file {
    $install_dir_parents:
      ensure => directory,
      mode   => '0644',
      owner  => 'root',
      group  => 'root';

   $installpath:
     ensure => directory,
     mode   => '0644',
     owner  => $yum::user,
     group  => $yum::deploy_group,
  }

  exec { 'createrepo':
    command => "/usr/bin/createrepo --database $installpath",
    require => [
      File[$installpath],
      Package['createrepo']
    ],
    creates => "$installpath/repodata",
  }
}

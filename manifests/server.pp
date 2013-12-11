class yum::server(
  $manage_firewall = hiera('manage_firewall', false)
) {
  $installpath     = $yum::installpath
  $server_name     = $yum::server_name
  $port            = $yum::port

  anchor { 'yum::server::start': }

  nginx::site { 'yum':
    ensure              => present,
    listen              => $port,
    server_name         => $server_name,
    locations           => [
      { '/' => {
          'sendfile'          => 'off',
          'tcp_nopush'        => 'off',
          'if_modified_since' => 'before',
          'root'              => $installpath
        }
      }
    ],
    require             => Anchor['yum::server::start'],
    before              => Anchor['yum::server::end'],
  }

  if $manage_firewall {
    firewall { "200 allow nginx:$port":
      proto   => 'tcp',
      state   => ['NEW'],
      dport   => $port,
      action  => 'accept',
      require => Anchor['yum::server::start'],
      before  => Anchor['yum::server::end'],
    }
  }
  anchor { 'yum::server::end': }
}

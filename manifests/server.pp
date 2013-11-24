class yum::server {
  $installpath     = $yum::installpath
  $server_name     = $yum::server_name
  $manage_firewall = $yum::manage_firewall
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

  firewall { "200 allow nginx:$port":
    proto   => 'tcp',
    state   => ['NEW'],
    dport   => $port,
    action  => 'accept',
  }

  anchor { 'yum::server::end': }
}

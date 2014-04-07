class yum::server {
  $installpath     = $yum::installpath
  $server_name     = $yum::server_name
  $port            = $yum::port

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
  }
}

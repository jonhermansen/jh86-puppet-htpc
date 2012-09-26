class htpc::couchpotato {

  exec { 'git_clone_couchpotato':
    command => 'git clone --depth 1 git://github.com/RuudBurger/CouchPotatoServer.git couchpotato',
    require => Package['git'],
    cwd     => '/opt',
    path    => '/usr/bin',
  }

}

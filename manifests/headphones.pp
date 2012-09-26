class htpc::headphones {

  exec { 'git_clone_headphones':
    command => 'git clone --depth 1 git://github.com/rembo10/headphones.git',
    require => Package['git'],
    cwd     => '/opt',
    path    => '/usr/bin',
  }

}

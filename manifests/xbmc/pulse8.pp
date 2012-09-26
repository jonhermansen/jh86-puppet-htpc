class htpc::xbmc::pulse8 inherits htpc::xbmc {

  file { '/etc/apt/sources.list.d/xbmc-pulseeight-stable.list':
    ensure  => 'file',
    content => "deb http://packages.pulse-eight.net/ubuntu precise stable\n",
  }

  exec { 'apt_get_update':
    command     => 'apt-get update',
    path        => '/usr/bin',
    subscribe   => File['/etc/apt/sources.list.d/xbmc-pulseeight-stable.list'],
    refreshonly => true
  }

  Package['xbmc'] {
    ensure +> '2:11.0-pvr+pulse8~git20120803.6e1de0b-0ubuntu1~build95~precise',
  }

}

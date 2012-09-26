# == Class: htpc
#
# Full description of class htpc here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Examples
#
#  class { htpc:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ]
#  }
#
# === Authors
#
# Jon Hermansen <jon@jh86.org>
#
# === Copyright
#
# Copyright 2012 Jon Hermansen, unless otherwise noted.
#
class htpc {

  # comment out or adjust this part, as necessary :)
  $my_packages = [ 'aptitude', 'bash', 'emacs23', 'openssh-server', 'screen', 'tmux' ]
  package { $my_packages: ensure => installed }

  $min_packages = [ 'git' ]
  package { $min_packages: ensure => installed }

  # frontend
  include htpc::xbmc
  include htpc::xbmc::pulse8 # disable if you don't need libcec support

  # # backend?
  include htpc::sabnzbd
  # include htpc::sickbeard
  # include htpc::couchpotato
  # include htpc::headphones

  git_web_service { 'sickbeard':
    uid => 998,
    gid => 998,
    url => 'git://github.com/midgetspy/Sick-Beard.git',
  }

  git_web_service { 'couchpotato':
    uid => 997,
    gid => 997,
    url => 'git://github.com/RuudBurger/CouchPotatoServer.git',
  }

  git_web_service { 'headphones':
    uid => 996,
    gid => 996,
    url => 'git://github.com/rembo10/headphones.git',
  }

  define git_web_service ( $user = $title, $group = $title, $uid, $gid, $url ) {

    group { $user:
      gid => $uid,
    }

    user { $user:
      gid => $uid,
      uid => $uid,
      require => Group[$user],
    }

    file { "/opt/$user":
      ensure => directory,
      owner => $user,
      group => $user,
      recurse => true,
    }

    # vcsrepo { "/opt/$user":
    #   source => $url,
    #   provider => git,
    #   ensure => latest,
    #   force => true,
    #   user => $user,
    #   owner => $user,
    #   group => $user,
    #   require => File["/opt/$user"],
    # }

    exec { "git_sync_$user":
      command => "sudo -u $user git clone $url .; sudo -u $user git pull origin master",
      cwd => "/opt/$user",
      path => '/usr/bin',
      require => File["/opt/$user"],
    }
    
  }

}

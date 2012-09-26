class htpc::sabnzbd {

  git_web_service { 'sabnzbd':
    uid => 999,
    gid => 999,
    url => 'git://github.com/sabnzbd/sabnzbd.git',
  }

}

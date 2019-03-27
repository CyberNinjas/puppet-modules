# == Class: pam_aad
#
# Builds and installs pam_aad from source.
#
# === Examples
#
# include pam_aad
#
# === Authors
#
# Lucas Ramage <lramage@cyberninjas.com>
#
# === Copyright
#
# Copyright 2019 Lucas Ramage
#

class pam_aad(String $version = '0.0.1') {

  case $operatingsystem {
    'Debian','Ubuntu': { 
      include pam_aad::debian
        $pamdir = '/lib/x86_64-linux-gnu/security'
    }
    default: { notice "Unsupported operatingsystem ${operatingsystem}" }
  }

  exec {'download':
    cwd => '/tmp',
        path => ['/usr/bin', '/bin'],
        command => "curl -o pam_aad-${version}.tar.gz -L https://github.com/CyberNinjas/pam_aad/archive/${version}.tar.gz",
        created => "/tmp/pam_aad-${version}.tar.gz"
  }

  exec {'extract':
    cwd => '/tmp',
        path => ['/usr/bin', '/bin'],
        command => "tar xfvz pam_aad-${version}.tar.gz",
        creates => "/tmp/pam_aad-${version}",
        require => Exec['download']
  }

  exec {'bootstrap':
    cwd => "/tmp/pam_aad-${version}",
        path => ['/usr/bin', '/bin'],
        command => 'sh -c "./bootstrap.sh"',
        creates => "/tmp/pam_aad-${version}/configure",
        require => [Package[automake],
        Package[build-essential],
        Package[libcurl-dev],
        Package[libjansson-dev],
        Package[libpam-dev],
        Package[libssl-dev],
        Package[libtool],
        Package[libuuid-dev],
        Package[pkg-config],
        Exec['extract']]
  }

  exec {'configure':
    cwd => "/tmp/pam_aad-${version}",
        path => ['/usr/bin', '/bin'],
        command => 'sh -c "./configure --with-pamdir=${pamdir}"',
        creates => "/tmp/pam_aad-${version}/config.status",
        require => ['bootstrap']
  }

  exec {'make':
    cwd => "/tmp/pam_aad-${version}",
        path => ['/usr/bin', '/bin'],
        command => 'sh -c make',
        creates => "/tmp/pam_aad-${version}/.libs/pam_aad.so",
        require => Exec['configure']
  }

  exec {'install':
    cwd => "/tmp/pam_aad-${version}",
        path => ['/usr/bin', '/bin'],
        command => 'sh -c make install',
        creates => "${pamdir}/pam_aad.so",
        require => Exec['make']
  }
}

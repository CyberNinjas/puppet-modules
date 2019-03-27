# == Class: libnss_aad
#
# Builds and installs libnss_aad from source.
#
# === Examples
#
# include libnss_aad
#
# === Authors
#
# Lucas Ramage <lramage@cyberninjas.com>
#
# === Copyright
#
# Copyright 2019 Lucas Ramage
#

class libnss_aad(String $version = '0.0.1') {

  case $::operatingsystem {
    'Debian','Ubuntu': {
      include libnss_aad::debian
      $libdir = '/lib/x86_64-linux-gnu'
    }
    default: { notice "Unsupported operatingsystem ${::operatingsystem}" }
  }

  exec { 'download':
    cwd     => '/tmp',
    path    => ['/usr/bin', '/bin'],
    command => "curl -o libnss_aad-${version}.tar.gz -L https://github.com/CyberNinjas/libnss_aad/archive/${version}.tar.gz",
    created => "/tmp/libnss_aad-${version}.tar.gz"
  }

  exec { 'extract':
    cwd     => '/tmp',
    path    => ['/usr/bin', '/bin'],
    command => "tar xfvz libnss_aad-${version}.tar.gz",
    creates => "/tmp/libnss_aad-${version}",
    require => Exec['download']
  }

  exec { 'make-depends':
    cwd     => "/tmp/libnss_aad-${version}",
    path    => ['/usr/bin', '/bin'],
    command => 'sh -c "make depends"',
    creates => "/tmp/libnss_aad-${version}/linux-pam/config.h",
    require => [Package[automake],
                Package[autopoint],
                Package[build-essential],
                Package[libcurl-dev],
                Package[libjansson-dev],
                Package[libpam-dev],
                Package[libsodium-dev],
                Package[libssl-dev],
                Package[libtool],
                Package[pkg-config],
                Exec['extract']]
  }

  exec { 'make-install':
    cwd     => "/tmp/libnss_aad-${version}",
    path    => ['/usr/bin', '/bin'],
    command => "sh -c \"LIB_DIR=${libdir} make -e install\"",
    creates => "${libdir}/libnss_aad.so.2",
    require => Exec['make-depends']
  }
}

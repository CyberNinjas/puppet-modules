# == Class: libnss_aad::deps::libjwt
#
# Builds and installed libjwt from source.
#
# === Authors
#
# Lucas Ramage <lramage@cyberninjas.com>
#
# === Copyright
#
# Copyright 2019 Lucas Ramage
#

class libnss_aad::deps::libjwt($version = '1.10.1') {

  exec {'clone':
    cwd     => '/tmp',
    path    => ['/usr/bin', '/bin'],
    command => 'git clone https://github.com/benmcollins/libjwt',
    created => '/tmp/libjwt'
  }

  exec {'checkout':
    cwd     => '/tmp/libjwt',
    path    => ['/usr/bin', '/bin'],
    command => "git checkout tags/v${version}",
    require => Exec['clone']
  }

  exec {'bootstrap':
    cwd     => '/tmp/libjwt',
    path    => ['/usr/bin', '/bin'],
    command => 'autoreconf -i',
    creates => "/tmp/libnss_aad-${version}/configure",
    require => [Package[build-essential],
                Package[libjansson-dev],
                Package[libssl-dev],
                Exec['checkout']]
  }

  exec {'configure':
    cwd     => '/tmp/libjwt',
    path    => ['/usr/bin', '/bin'],
    command => 'sh -c "./configure"',
    creates => '/tmp/libjwt/config.status',
    require => ['bootstrap']
  }

  exec {'make':
    cwd     => '/tmp/libjwt',
    path    => ['/usr/bin', '/bin'],
    command => 'sh -c make',
    creates => "/tmp/libjwt/.libs/libjwt.so.${version}",
    require => Exec['configure']
  }

  exec {'install':
    cwd     => '/tmp/libjwt',
    path    => ['/usr/bin', '/bin'],
    command => 'sh -c make install',
    creates => "/usr/local/lib/libjwt.so.${version}",
    require => Exec['make']
  }
}

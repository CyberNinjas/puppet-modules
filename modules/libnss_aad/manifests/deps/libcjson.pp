# == Class: libnss_aad::deps::libcjson
#
# Builds and installed libcjson from source.
#
# === Authors
#
# Lucas Ramage <lramage@cyberninjas.com>
#
# === Copyright
#
# Copyright 2019 Lucas Ramage
#

class libnss_aad::deps::libcjson($version = '1.7.10') {

  exec {'clone':
    cwd     => '/tmp',
    path    => ['/usr/bin', '/bin'],
    command => 'git clone https://github.com/DaveGamble/cJSON libcjson',
    created => '/tmp/libcjson'
  }

  exec {'checkout':
    cwd     => '/tmp/libcjson',
    path    => ['/usr/bin', '/bin'],
    command => "git checkout tags/v${version}",
    require => Exec['clone']
  }

  file { '/tmp/libcjson/build':
    ensure  => 'directory',
    require => Exec['checkout']
  }

  exec {'cmake':
    cwd     => '/tmp/libcjson/build',
    path    => ['/usr/bin', '/bin'],
    command => 'sh -c "cmake .."',
    creates => '/tmp/libcjson/build/Makefile',
    require => File['/tmp/libcjson/build']
  }

  exec {'make':
    cwd     => '/tmp/libcjson/build',
    path    => ['/usr/bin', '/bin'],
    command => 'sh -c make',
    creates => "/tmp/libcjson/.libs/libcjson.so.${version}",
    require => Exec['cmake']
  }

  exec {'install':
    cwd     => '/tmp/libcjson/build',
    path    => ['/usr/bin', '/bin'],
    command => 'sh -c make install',
    creates => "/usr/local/lib/libcjson.so.${version}",
    require => Exec['make']
  }
}

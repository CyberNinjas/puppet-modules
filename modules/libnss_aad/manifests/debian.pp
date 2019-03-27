# == Class: libnss_aad::debian
#
# Installs build dependencies for Debian.
#
# === Authors
#
# Lucas Ramage <lramage@cyberninjas.com>
#
# === Copyright
#
# Copyright 2019 Lucas Ramage
#

class libnss_aad::debian {

  # TODO See: https://github.com/puppetlabs/puppetlabs-apt
  exec { 'apt-update':
    path    => ['/usr/bin', '/bin'],
    command => 'apt-get update'
  }

  package { 'automake':
    ensure  => installed,
    require => Exec['apt-update'],
  }

  package { 'autopoint':
    ensure  => installed,
    require => Exec['apt-update'],
  }

  package { 'build-essential':
    ensure  => installed,
    require => Exec['apt-update'],
  }

  package { 'cmake':
    ensure  => installed,
    require => Exec['apt-update'],
  }

  package { 'git':
    ensure  => installed,
    require => Exec['apt-update'],
  }

  package { 'libcurl4-openssl-dev':
    ensure  => installed,
    require => Exec['apt-update'],
    alias   => 'libcurl-dev'
  }

  package { 'libjansson-dev':
    ensure  => installed,
    require => Exec['apt-update'],
  }

  package { 'libpam0g-dev':
    ensure  => installed,
    require => Exec['apt-update'],
    alias   => 'libpam-dev'
  }

  package { 'libsodium-dev':
    ensure  => installed,
    require => Exec['apt-update'],
  }

  package { 'libssl-dev':
    ensure  => installed,
    require => Exec['apt-update'],
  }

  package { 'libtool':
    ensure  => installed,
    require => Exec['apt-update'],
    alias   => 'libtool'
  }

  package { 'pkg-config':
    ensure  => installed,
    require => Exec['apt-update'],
  }

  require libnss_aad::deps::libcjson
  require libnss_aad::deps::libjwt
  require libnss_aad::deps::libsds
}

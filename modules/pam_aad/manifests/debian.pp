# == Class: pam_aad::debian
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

class pam_aad::debian {

  # TODO See: https://github.com/puppetlabs/puppetlabs-apt
  exec { 'apt-update':
    path    => ['/usr/bin', '/bin'],
    command => 'apt-get update'
  }

  package { 'automake':
    ensure  => installed,
    require => Exec['apt-update'],
  }

  package { 'build-essential':
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

  package { 'uuid-dev':
    ensure  => installed,
    require => Exec['apt-update'],
    alias   => 'libuuid-dev'
  }

  require pam_aad::deps::libjwt
    require pam_aad::deps::libsds
}

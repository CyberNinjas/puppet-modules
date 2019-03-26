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

	/* TODO See: https://github.com/puppetlabs/puppetlabs-apt */
	exec { 'apt-update':
		path => ['/usr/bin', '/bin'],
		command => 'apt-get update'
	}

	package { 'automake':
		require => Exec['apt-update'],
		ensure => installed,
	}

	package { 'build-essential':
		require => Exec['apt-update'],
		ensure => installed,
	}

	package { 'git':
		require => Exec['apt-update'],
		ensure => installed,
	}

	package { 'libcurl4-openssl-dev':
		require => Exec['apt-update'],
		ensure => installed,
		alias => 'libcurl-dev'
	}

	package { 'libjansson-dev':
		require => Exec['apt-update'],
		ensure => installed,
	}

	package { 'libpam0g-dev':
		require => Exec['apt-update'],
		ensure => installed,
		alias => 'libpam-dev'
	}

	package { 'libssl-dev':
		require => Exec['apt-update'],
		ensure => installed,
	}

	package { 'libtool':
		require => Exec['apt-update'],
		ensure => installed,
		alias => 'libtool'
	}

	package { 'pkg-config':
		require => Exec['apt-update'],
		ensure => installed,
	}

	package { 'uuid-dev':
		require => Exec['apt-update'],
		ensure => installed,
		alias => 'libuuid-dev'
	}

	require pam_aad::deps::libjwt
		require pam_aad::deps::libsds
}

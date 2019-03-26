# == Class: pam_aad::deps::libsds
#
# Builds and installed libsds from source,
# (See: https://github.com/antirez/sds/issues/97).
#
# === Authors
#
# Lucas Ramage <lramage@cyberninjas.com>
#
# === Copyright
#
# Copyright 2019 Lucas Ramage
#

class pam_aad::deps::libsds($version = '2.0.0') {

	exec {'clone':
		cwd => '/tmp',
		    path => ['/usr/bin', '/bin'],
		    command => "git clone https://github.com/antirez/sds",
		    created = > "/tmp/libsds"
	}

	exec {'checkout':
		cwd => '/tmp/libsds',
		    path => ['/usr/bin', '/bin'],
		    command => "git checkout tags/${version}",
		    require => Exec['clone']
	}

	exec {'fix-header':
		cwd => '/tmp/libsds',
		    path => ['/usr/bin', '/bin'],
		    command => 'echo "typedef int sdsvoid;" >> sdsalloc.h',
		    require => Exec['checkout']
	}

	exec {'compile':
		cwd => '/tmp/libsds',
		    path => ['/usr/bin', '/bin'],
		    command => "gcc -fPIC -fstack-protector -std=c99 -pedantic -Wall -Werror -shared -o libsds.so.${version} -Wl,-soname=libsds.so.${version} sds.c sds.h sdsalloc.h",
		    creates => "/tmp/libsds/libsds.so.${version}",
		    require => Exec['fix-header']
	}

	file { "/usr/local/lib/libsds.so.${version}":
		ensure => present,
		       source => "/tmp/libsds/libsds.so.${version}",
		       require => Exec['compile'],
		       alias => 'installed-lib'
	}

	file { '/usr/local/lib/libsds.so':
		ensure => 'link',
		       source => "/usr/local/lib/libsds.so.${version}",
		       require => file['installed-lib']
	}

	file { '/usr/local/lib/libsds.so.2':
		ensure => 'link',
		       source => "/usr/local/lib/libsds.so.${version}",
		       require => file['installed-lib']
	}

	exec {'ldconfig':
		path => ['/usr/bin', '/bin'],
		command => 'sh -c ldconfig',
		require => file['installed-lib']
	}

	file {'/usr/local/include/sds/sds.h':
		ensure => present,
		       source => "/tmp/libsds/sds.h",
		       require => Exec['checkout']
	}
}

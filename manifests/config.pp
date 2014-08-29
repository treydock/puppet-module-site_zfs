# == Class: site_zfs::config
#
# Private
#
class site_zfs::config {

  $mk_vdev_alias_ensure = $::site_zfs::mk_vdev_alias_ensure ? {
    'UNSET' => $::site_zfs::file_default_ensure,
    default => $::site_zfs::mk_vdev_alias_ensure,
  }

  $sas2vdev_ensure = $::site_zfs::sas2vdev_ensure ? {
    'UNSET' => $::site_zfs::file_default_ensure,
    default => $::site_zfs::sas2vdev_ensure,
  }

  file { '/usr/local/sbin/mk_vdev_alias.rb':
    ensure  => $mk_vdev_alias_ensure,
    source  => 'puppet:///modules/site_zfs/scripts/mk_vdev_alias.rb',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

  file { '/usr/local/sbin/sas2vdev.rb':
    ensure  => $sas2vdev_ensure,
    source  => 'puppet:///modules/site_zfs/scripts/sas2vdev.rb',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Package['sas2ircu'],
  }

}

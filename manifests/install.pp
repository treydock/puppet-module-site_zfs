# == Class: site_zfs::install
#
# Private
#
class site_zfs::install {

  $sas2ircu_ensure = $::site_zfs::sas2ircu_ensure ? {
    'UNSET' => $::site_zfs::package_default_ensure,
    default => $::site_zfs::sas2ircu_ensure,
  }

  $simplesnap_ensure = $::site_zfs::simplesnap_ensure ? {
    'UNSET' => $::site_zfs::package_default_ensure,
    default => $::site_zfs::simplesnap_ensure,
  }

  $zfsnap_ensure = $::site_zfs::zfsnap_ensure ? {
    'UNSET' => $::site_zfs::package_default_ensure,
    default => $::site_zfs::zfsnap_ensure,
  }

  package { 'sas2ircu':
    ensure  => $sas2ircu_ensure,
    require => $::site_zfs::package_require,
  }

  package { 'simplesnap':
    ensure  => $simplesnap_ensure,
    require => $::site_zfs::package_require,
  }

  package { 'zfsnap':
    ensure  => $zfsnap_ensure,
    require => $::site_zfs::package_require,
  }

}

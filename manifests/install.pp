# == Class: site_zfs::install
#
# Private
#
class site_zfs::install {

  $sas2ircu_ensure = $::site_zfs::sas2ircu_ensure ? {
    'UNSET' => $::site_zfs::package_default_ensure,
    default => $::site_zfs::sas2ircu_ensure,
  }

  package { 'sas2ircu':
    ensure  => $sas2ircu_ensure,
    require => $::site_zfs::package_require,
  }

}

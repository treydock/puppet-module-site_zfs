# == Class: site_zfs
#
class site_zfs (
  $ensure = 'present',
  $package_require = undef,
  $sas2ircu_ensure = 'UNSET',
  $simplesnap_ensure = 'UNSET',
  $zfsnap_ensure = 'UNSET',
  $mk_vdev_alias_ensure = 'UNSET',
  $sas2vdev_ensure = 'UNSET',
  $enable_zfs_send = false,
) {

  case $ensure {
    'present': {
      $package_default_ensure = 'installed'
      $file_default_ensure    = 'file'
    }
    'absent': {
      $package_default_ensure = 'absent'
      $file_default_ensure    = 'absent'
    }
    default: {
      fail("${module_name}: ensure parameter must be 'present' or 'absent', ${ensure} given.")
    }
  }

  validate_bool($enable_zfs_send)

  if $enable_zfs_send {
    $remote_zfs_file_ensure = $file_default_ensure
  } else {
    $remote_zfs_file_ensure = 'absent'
  }

  anchor { 'site_zfs::begin': }->
  class { 'site_zfs::install': }->
  class { 'site_zfs::config': }->
  anchor { 'site_zfs::end': }

}

require 'spec_helper'

describe 'site_zfs' do
  include_context :defaults

  let(:facts) { default_facts }

  it { should create_class('site_zfs') }
  it { should contain_anchor('site_zfs::begin').that_comes_before('Class[site_zfs::install]') }
  it { should contain_class('site_zfs::install').that_comes_before('Class[site_zfs::config]') }
  it { should contain_class('site_zfs::config').that_comes_before('Anchor[site_zfs::end]') }
  it { should contain_anchor('site_zfs::end') }

  context 'site_zfs::install' do
    it do
      should contain_package('sas2ircu').with({
        :ensure   => 'installed',
        :require  => nil,
      })
    end

    it do
      should contain_package('simplesnap').with({
        :ensure   => 'installed',
        :require  => nil,
      })
    end

    it do
      should contain_package('zfsnap').with({
        :ensure   => 'installed',
        :require  => nil,
      })
    end

    context "when ensure => 'absent'" do
      let(:params) {{ :ensure => 'absent' }}
      it { should contain_package('sas2ircu').with_ensure('absent') }
      it { should contain_package('simplesnap').with_ensure('absent') }
      it { should contain_package('zfsnap').with_ensure('absent') }
    end

    context "when package_require => 'Yumrepo[foo]'" do
      let(:params) {{ :package_require => 'Yumrepo[foo]' }}
      it { should contain_package('sas2ircu').with_require('Yumrepo[foo]') }
      it { should contain_package('simplesnap').with_require('Yumrepo[foo]') }
      it { should contain_package('zfsnap').with_require('Yumrepo[foo]') }
    end
  end

  context 'site_zfs::config' do
    it do
      should contain_file('/usr/local/sbin/mk_vdev_alias.rb').with({
        :ensure   => 'file',
        :source   => 'puppet:///modules/site_zfs/scripts/mk_vdev_alias.rb',
        :owner    => 'root',
        :group    => 'root',
        :mode     => '0755',
      })
    end


    it do
      should contain_file('/usr/local/sbin/sas2vdev.rb').with({
        :ensure   => 'file',
        :source   => 'puppet:///modules/site_zfs/scripts/sas2vdev.rb',
        :owner    => 'root',
        :group    => 'root',
        :mode     => '0755',
        :require  => 'Package[sas2ircu]',
      })
    end

    context "when ensure => 'absent'" do
      let(:params) {{ :ensure => 'absent' }}
      it { should contain_file('/usr/local/sbin/mk_vdev_alias.rb').with_ensure('absent') }
      it { should contain_file('/usr/local/sbin/sas2vdev.rb').with_ensure('absent') }
    end
  end

  context "when ensure => 'foo'" do
    let(:params) {{ :ensure => 'foo' }}
    it "should fail" do
      expect { should compile }.to raise_error(/site_zfs: ensure parameter must be 'present' or 'absent', foo given./)
    end
  end
end

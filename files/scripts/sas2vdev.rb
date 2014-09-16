#!/usr/bin/env ruby

require 'rubygems'
require 'pp'

VDEV_PREFIX = 'd'

unless system('which sas2ircu &>/dev/null')
  puts "ERROR: command not found - sas2ircu"
  exit 1
end

drives = []
controller_count = `sas2ircu LIST | grep -c -E '^\s+Index'`.strip.to_i
(0..(controller_count-1)).each do |n|
  output = `sas2ircu #{n} DISPLAY`

  drives_output = output.split(/^$/)

  drives_output.each do |output|
    d = {}
    output.each_line do |line|
      case line
      when /Slot \#\s+: ([0-9]+)$/
        d['slot'] = $1
      when /SAS Address\s+:\s(.*)$/
        d['address'] = $1.gsub('-', '')
      when /GUID\s+: (.*)$/
        d['guid'] = $1
      end
    end

    drives << d unless d['guid'].nil? or d['guid'] == 'N/A'
  end
end

drives.each do |drive|
  Dir['/dev/disk/by-id/*'].each do |id_dev|
    if File.basename(id_dev) =~ /wwn-0x#{drive['guid']}$/
      drive['name'] = File.basename(File.readlink(id_dev))
      Dir['/dev/disk/by-path/*'].each do |path_dev|
        if File.basename(File.readlink(path_dev)) == drive['name']
          drive['path'] = path_dev
        end
      end
    end
  end
end

drives.each_with_index do |drive,i|
  vdev = "%02d" % (i.to_i + 1)
  puts "alias #{VDEV_PREFIX}#{vdev} #{drive['path']}"
end

exit 0

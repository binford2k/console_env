# == Class: console_env
#
# This is the console-env module. It was written with the sole purpose of adding the ability to specify environments in the console using key/value pairs
#
# === Important
#
# This Module only works to add functionality to the Puppet Enterprise Console
#
# Under the hood the module is using an awk script extracting the value for the environment parameter if it exists, if the environment paramater is found it is
# appended it to the environment stanza to the bottom of what is returned via the ENC scripts curl.
#
#
# === The updated class
# Now allows you to ensure the state of console_env
# You can now use:
# ensure => present,
# And likewise
# ensure => absent,
# === Parameter in Console
#
# Now using the node or group in the console you can set the environment key value pair
#
# environment => YOURENVIRONMENT
#
#
# === Author
#
# Jay Wallace <jay@puppetlabs.com>
#
# === Copyright
#
# Copyright 2013 Jay Wallace
#
# === Notes.
# Essentially this module looks for an environment parameter and appends it at top scope to the data returned by the upstream ENC.
# If you run into any issues just ensure => absent to return the ENC to its original functionality.
#
# Feel free to just use the ENC script if you do not prefer to use the module. I promise I won't be offended.
#
# This is not the most elegant solution, but it works.
class console_env (
  $ensure = present,
) {
  $dashboard_path = '/etc/puppetlabs/puppet-dashboard'

  file { "${dashboard_path}/external_node.rb":
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '755',
    content => template('console_env/external_node.rb.erb'),
  }

  case $ensure  {
    present: { $external_nodes = "${dashboard_path}/external_node.rb"   }
    absent : { $external_nodes = "${dashboard_path}/external_node."     }
    default: { fail("console_env: unsupported ensure value ${ensure}") }
  }

  ini_setting { "console_env-external_node":
    ensure  => present,
    path    => '/etc/puppetlabs/puppet/puppet.conf',
    section => 'master',
    setting => 'external_nodes',
    value   => $external_nodes,
    require => File["${dashboard_path}/external_node.rb"],
  }

}

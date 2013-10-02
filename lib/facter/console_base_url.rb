Facter.add(:console_base_url) do
  setcode "grep '^ENC' /etc/puppetlabs/puppet-dashboard/external_node | cut -f 2 -d '\"'"
end


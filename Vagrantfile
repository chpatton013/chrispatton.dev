VAGRANT_CONFIG_PATH = "#{__dir__}/.vagrant"
VAGRANT_VM_PROVIDER = "virtualbox"

class Machine
  attr_reader :name
  attr_reader :box
  attr_reader :hostname
  attr_reader :static_ip
  attr_reader :groups

  def initialize(name:, box:, hostname:, static_ip:, groups:)
    @name = name
    @box = box
    @hostname = hostname
    @static_ip = static_ip
    @groups = groups
  end

  def define(config)
    config.vm.define @name do |machine_config|
      machine_config.vm.box = @box
      machine_config.vm.hostname = @hostname
      machine_config.vm.network :private_network, ip: @static_ip
      machine_config.vm.network :forwarded_port, guest: 22, host: 2222, auto_correct: true
      yield machine_config
    end
  end

  def ssh_arg()
    return "-o IdentityFile=#{VAGRANT_CONFIG_PATH}/machines/#{@name}/#{VAGRANT_VM_PROVIDER}/private_key"
  end
end

MACHINES = [
  # Machine.new(name: "web", box: "archlinux/archlinux", hostname: "web", static_ip: "10.0.0.11", groups: []),
  # Machine.new(name: "mx", box: "archlinux/archlinux", hostname: "mx", static_ip: "10.0.0.21", groups: ["mail"]),
  # Machine.new(name: "db", box: "archlinux/archlinux", hostname: "db", static_ip: "10.0.0.31", groups: ["database"]),
  # Machine.new(name: "cache", box: "archlinux/archlinux", hostname: "db", static_ip: "10.0.0.41", groups: ["cache"]),
  # Machine.new(name: "filter", box: "archlinux/archlinux", hostname: "filter", static_ip: "10.0.0.51", groups: []),
]

Vagrant.configure("2") do |config|
  ANSIBLE_RAW_SSH_ARGS = MACHINES.map { |machine| machine.ssh_arg }
  ANSIBLE_GROUPS = Hash.new {|hash, key| hash[key] = [] }
  MACHINES.each do |machine|
    machine.groups.each do |group|
      ANSIBLE_GROUPS[group].push machine.name
    end
  end

  MACHINES.each_index do |machine_index|
    machine = MACHINES[machine_index]

    machine.define config do |machine_config|
      machine_config.vm.provision :shell, path: "vagrant/provision.sh"
      machine_provision_script = "vagrant/provision.#{machine.name}.sh"
      if File.file?(machine_provision_script)
        machine_config.vm.provision :shell, path: machine_provision_script
      end

      # Do not run Ansible provisioning until the last machine so we can connect
      # to all of them in parallel.
      if machine_index == MACHINES.length - 1
        machine_config.vm.provision :ansible do |ansible|
          ansible.verbose = true
          ansible.raw_arguments = ["-v"]

          # Provision all machines in parallel.
          ansible.limit = "all"

          ansible.playbook = "ansible/provision.playbook.yml"
          ansible.groups = ANSIBLE_GROUPS
          ansible.extra_vars = "@vagrant/vars.yml"
          ansible.raw_ssh_args = ANSIBLE_RAW_SSH_ARGS
          ansible.raw_arguments = "--extra-vars=vagrant_vars_dir=#{__dir__}/vagrant"
        end
      end
    end

  end

end

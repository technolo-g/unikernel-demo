# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  #config.ssh.username = "vagrant"
  #config.ssh.password = "vagrant"
  # VMware Configuration
  config.vm.provider "vmware_fusion" do |provider, override|
    override.vm.box = "vmware-xen-trusty64.box"
    override.vm.box_url = 'https://s3-us-west-2.amazonaws.com/technolo-g/vagrant-boxes/ubuntu/vmware-xen-trusty64.box'
    override.vm.box_check_update = false
  end
  config.vm.provider "vmware_fusion" do |v|
    v.vmx["memsize"] = '2048'
    v.vmx["numvcpus"] = '2'
    v.gui = true
  end

  # VirtualBox Configuration
  config.vm.provider "virtualbox" do |provider, override|
    override.vm.box = "vbox-xen-trusty64.box"
    override.vm.box_url = 'https://s3-us-west-2.amazonaws.com/technolo-g/vagrant-boxes/ubuntu/vbox-xen-trusty64.box'
    override.vm.box_check_update = false
  end
  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 2
  end

  config.vm.synced_folder ".", "/home/vagrant/testn-autoproxy", type: "nfs"
  config.vm.network "private_network", ip: "10.100.199.35"

end

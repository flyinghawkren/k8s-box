# -*- mode: ruby -*-
# vi: set ft=ruby :

k8s_version = "1.11.10-00"
docker_version = "17.03.3~ce-0~ubuntu-xenial"

Vagrant.configure(2) do |config|
  config.ssh.insert_key = false
  config.vm.box = "ubuntu/xenial64"

  # Bring up the Devstack ovsdb/ovn-northd node on Virtualbox
  config.vm.define "k8s" do |k8snode|
    k8snode.vm.provision "shell", path: "setup-k8s.sh", privileged: false,
      :args => "#{k8s_version} #{docker_version}"
    k8snode.vm.provider "virtualbox" do |vb|
       vb.customize [
           'modifyvm', :id,
           '--nicpromisc3', "allow-all"
          ]
       vb.customize [
           "guestproperty", "set", :id,
           "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 10000
          ]
    end
  end

  config.vm.provider "virtualbox" do |v|
    v.default_nic_type = "82543GC"
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    v.customize ["modifyvm", :id, "--nictype1", "virtio"]
  end
end

# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu-18/bionic64"
  config.vm.hostname = "ubuntu"                               # Hostname
  config.vm.define "ubuntu"                                   # Имя в окружении Vagrant
  config.vm.box_check_update = false
  config.vm.network "private_network", :type => 'dhcp'        #'192.168.56.X', :netmask => '255.255.255.0'
  #config.vm.network "private_network", :type => 'dhcp'
  #config.vm.network "public_network", ip: "10.0.2.222"

  config.vm.provider "virtualbox" do |vb|
    vb.name = "Server_03_10"                                  # Имя виртуальной машины в VirtualBox
    vb.memory = "4096"#
    vb.cpus = 2                                               #Колличество процессоров
    vb.customize ["modifyvm", :id, "--cpuexecutioncap", "50"] #Ограничение потребление ресурсов процессора
    vb.customize ["modifyvm", :id, "--nic1", "nat",]
    vb.customize ["modifyvm", :id, "--nic2", "natnetwork"]
    vb.customize ["modifyvm", :id, "--nat-network2", "natnetwork"]
    #vb.customize ["modifyvm", :id, "--nic2", "hostonly"]
  end

   config.vm.provision "shell", inline: <<-SHELL
  #   echo "Test ping"  
  #     ping -c 3 ya.ru
  #   echo "Update and upgrade system"
  #     sudo apt-get update -y
  #     sudo apt-get upgrade -y
  #     uname -srm > /home/vagrant/kernal.txt
  #     sudo apt-get install, mc -y
        ip addr
  SHELL
end
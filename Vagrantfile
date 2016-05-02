# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.box = "ubuntu/trusty64"
  config.vm.provision :shell, path: "installRabbit.sh"
  config.vm.network :forwarded_port, host: 5671, guest: 5672
  config.vm.network :forwarded_port, host: 15671, guest: 15672
  
end

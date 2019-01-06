# -*- mode: ruby -*-
# vi: set ft=ruby :

$docker_swarm_init = <<SCRIPT
docker swarm init --advertise-addr 192.168.99.101 --listen-addr 192.168.99.101:2377
docker swarm join-token --quiet worker > /vagrant/worker_token
SCRIPT

Vagrant.configure("2") do |config|
	# https://app.vagrantup.com/ralfkrause/boxes/centos7
	config.vm.box 									= "ralfkrause/centos7"
	config.hostmanager.enabled 			= true
	config.hostmanager.manage_host 	= true
	config.hostmanager.manage_guest = true
	config.vm.provision "docker"

	config.vm.define "node1", primary: true do |node1|
		node1.vm.hostname = 'node1'
		node1.vm.network :private_network, ip: "192.168.99.101"
		node1.vm.provider :virtualbox do |vb|
			vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
			vb.customize ["modifyvm", :id, "--memory", 8000]
			vb.customize ["modifyvm", :id, "--name", "node1"]
		end
		node1.vm.provision :shell, inline: $docker_swarm_init
	end

	config.vm.define "node2" do |node2|
		node2.vm.hostname = 'node2'
		node2.vm.network :private_network, ip: "192.168.99.102"
		node2.vm.provider :virtualbox do |vb|
			vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
			vb.customize ["modifyvm", :id, "--memory", 2000]
			vb.customize ["modifyvm", :id, "--name", "node2"]
		end
		node2.vm.provision :shell, inline: "docker swarm join --token $(cat /vagrant/worker_token) 192.168.99.101:2377"
	end

end

# -*- mode: ruby -*-
# vi: set ft=ruby :

# Installing the following tools is a prerequisite:  
## http://www.thisprogrammingthing.com/2015/multiple-vagrant-vms-in-one-vagrantfile/
## https://github.com/devopsgroup-io/vagrant-hostmanager

$docker_swarm_init = <<SCRIPT
docker swarm init --advertise-addr 192.168.99.101 --listen-addr 192.168.99.101:2377

JENKINS_HOME=/vagrant/jenkins_home
mkdir -p $JENKINS_HOME
chown -R 1000 $JENKINS_HOME

ANSIBLE_INVENTORY=/vagrant/ansible
mkdir -p $ANSIBLE_INVENTORY
chown -R 1000 $ANSIBLE_INVENTORY

SCRIPT

$docker_swarm_join = <<SCRIPT
apt-get install sshpass
sshpass -p vagrant ssh -oStrictHostKeyChecking=no vagrant@node1 docker swarm join-token -q worker
docker swarm join --token $(sshpass -p vagrant ssh -o StrictHostKeyChecking=no vagrant@node1 docker swarm join-token -q worker) 192.168.99.101:2377
SCRIPT

Vagrant.configure("2") do |config|	
	config.vm.box = "ubuntu/trusty64"
	# config.vm.box = "ubuntu/xenial64"
	config.hostmanager.enabled = true
	config.hostmanager.manage_host = true
	config.hostmanager.manage_guest = true
	config.vm.provision "docker"
	
	config.vm.define "node1", primary: true do |node1|
		node1.vm.hostname = 'node1'
		node1.vm.network :private_network, ip: "192.168.99.101"
		node1.vm.provider :virtualbox do |v|
			v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
			v.customize ["modifyvm", :id, "--memory", 4096]
			v.customize ["modifyvm", :id, "--name", "node1"]
		end
		node1.vm.provision :shell, inline: $docker_swarm_init
		node1.vm.provision "docker" do |d|
			d.run "visualizer", 
				image: "turaaa/swarmvisualizer",
				args: "-it -p 9080:9080 -e HOST=node1 -e PORT=9080 -v '/var/run/docker.sock:/var/run/docker.sock'"
		end
	end
	
	config.vm.define "node2" do |node2|
		node2.vm.hostname = 'node2'
		node2.vm.network :private_network, ip: "192.168.99.102"
		node2.vm.provider :virtualbox do |v|
			v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
			v.customize ["modifyvm", :id, "--memory", 4096]
			v.customize ["modifyvm", :id, "--name", "node2"]
		end
		node2.vm.provision :shell, inline: $docker_swarm_join
	end
	
	config.vm.define "node3" do |node3|
		node3.vm.hostname = 'node3'
		node3.vm.network :private_network, ip: "192.168.99.103"
		node3.vm.provider :virtualbox do |v|
			v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
			v.customize ["modifyvm", :id, "--memory", 2048]
			v.customize ["modifyvm", :id, "--name", "node3"]
		end
		node3.vm.provision :shell, inline: $docker_swarm_join
	end
	
#	config.vm.define "node4" do |node4|
#		node4.vm.hostname = 'node4'
#		node4.vm.network :private_network, ip: "192.168.99.104"
#		node4.vm.provider :virtualbox do |v|
#			v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
#			v.customize ["modifyvm", :id, "--memory", 1024]
#			v.customize ["modifyvm", :id, "--name", "node4"]
#		end
#		node4.vm.provision :shell, inline: $docker_swarm_join
#	end

end

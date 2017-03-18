# -*- mode: ruby -*-
# vi: set ft=ruby :

# Installing the following tools is a prerequisite:
## http://www.thisprogrammingthing.com/2015/multiple-vagrant-vms-in-one-vagrantfile/
## https://github.com/devopsgroup-io/vagrant-hostmanager

# https://sreeninet.wordpress.com/2017/01/27/docker-1-13-experimental-features/
$docker_experimental_mode = <<SCRIPT
mkdir -p /etc/systemd/system/docker.service.d
touch /etc/systemd/system/docker.service.d/docker.conf
echo [Service] > /etc/systemd/system/docker.service.d/docker.conf
echo ExecStart= >> /etc/systemd/system/docker.service.d/docker.conf
echo ExecStart=/usr/bin/dockerd -H fd:// --experimental=true >> /etc/systemd/system/docker.service.d/docker.conf
systemctl daemon-reload
systemctl restart docker
SCRIPT

$docker_swarm_init = <<SCRIPT
echo "============== Initializing swarm mode ====================="
sysctl -w vm.max_map_count=262144
docker swarm init --advertise-addr 192.168.99.101 --listen-addr 192.168.99.101:2377
docker swarm join-token --quiet manager > /vagrant/manager_token
docker swarm join-token --quiet worker > /vagrant/worker_token
SCRIPT

$docker_swarm_join_worker = <<SCRIPT
echo "============== Joining swarm cluster as worker ====================="
docker swarm join --token $(cat /vagrant/worker_token) 192.168.99.101:2377
SCRIPT

$docker_swarm_join_manager = <<SCRIPT
echo "============== Joining swarm cluster as manager ====================="
docker swarm join --token $(cat /vagrant/manager_token) 192.168.99.101:2377
SCRIPT

$update_pkg = <<SCRIPT
echo "============== Updating OS packages ====================="
apt -y update && apt -y upgrade
apt install -y python-pip && pip install --upgrade pip
SCRIPT

$install_compose = <<SCRIPT
echo "============== Installing docker compose ====================="
pip install docker-compose
docker-compose version
SCRIPT


Vagrant.configure("2") do |config|
	config.vm.box = "ubuntu/xenial64"
	config.hostmanager.enabled = true
	config.hostmanager.manage_host = true
	config.hostmanager.manage_guest = true
	config.vm.provision :shell, inline: $update_pkg
	config.vm.provision "docker"
	config.vm.provision :shell, inline: $install_compose

	config.vm.define "node1", primary: true do |node1|
		node1.vm.hostname = 'node1'
		node1.vm.network :private_network, ip: "192.168.99.101"
		node1.vm.provider :virtualbox do |v|
			v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
			v.customize ["modifyvm", :id, "--memory", 6144]
			v.customize ["modifyvm", :id, "--name", "node1"]
		end
		node1.vm.provision :shell, inline: $docker_experimental_mode
		node1.vm.provision :shell, inline: $docker_swarm_init
		node1.vm.provision "docker" do |d|
			d.run "visualizer",
				image: "turaaa/swarmvisualizer",
				args: "-it -p 9080:9080 -e HOST=node1 -e PORT=9080 -v '/var/run/docker.sock:/var/run/docker.sock'"
			d.run "portainer",
				image: "portainer/portainer",
				cmd: "-H unix:///var/run/docker.sock",
				args: "-p 9000:9000 -v '/var/run/docker.sock:/var/run/docker.sock' -v '/host/data:/data'"
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
		node2.vm.provision :shell, inline: $docker_experimental_mode
		node2.vm.provision :shell, inline: $docker_swarm_join_worker
	end

#	config.vm.define "node3" do |node3|
#		node3.vm.hostname = 'node3'
#		node3.vm.network :private_network, ip: "192.168.99.103"
#		node3.vm.provider :virtualbox do |v|
#			v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
#			v.customize ["modifyvm", :id, "--memory", 2048]
#			v.customize ["modifyvm", :id, "--name", "node3"]
#		end
#		node3.vm.provision :shell, inline: $docker_experimental_mode
#		node3.vm.provision :shell, inline: $docker_swarm_join_worker
#	end

#	config.vm.define "node4" do |node4|
#		node4.vm.hostname = 'node4'
#		node4.vm.network :private_network, ip: "192.168.99.104"
#		node4.vm.provider :virtualbox do |v|
#			v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
#			v.customize ["modifyvm", :id, "--memory", 3072]
#			v.customize ["modifyvm", :id, "--name", "node4"]
#		end
#		node4.vm.provision :shell, inline: $docker_experimental_mode
#		node4.vm.provision :shell, inline: $docker_swarm_join_manager
#	end

end

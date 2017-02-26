# Challenge:

-	Setting up a docker swarm cluster of 4 nodes
-	Deploy DevOps tools in swarm mode via a compose file


# Prerequisists:

-	Install Docker Toolbox (Includes Git Bash, Virtual Box)
-	Install Vagrant + Vagrant-hostmanager


# Instructions:

-	change to directory where vagrantfile is and run "vagrant up". This will setup a swarm cluster; 2xworkers and 2xmanagers. Furthermore this will deploy required dev tools as docker services.


The visualizer screen should look simialar to this:
![alt tag](https://github.com/shazChaudhry/techchallange/blob/master/VisualizerXXX.PNG)


# Test:

- 	Take a short break and wait until all services are started
-	Visualizer is at "http://node1:9080"
- 	Check Jenkins "http://node1/jenkins". Username: admin; Password: Password01
-	Check SonarQube "http://node1/sonar". Username: admin; Password: admin
-	Check Nexus "http://node1/nexus". Username: admin; Password: admin123


# Clean-up:
-	To remove services, execute "./removeStack.sh" in the /vagrant directory
-	To tear down the infrastructure, run "vagrant destroy"

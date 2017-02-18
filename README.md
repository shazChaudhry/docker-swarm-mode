# Challenge:

-	Setting up a docker swarm cluster of three nodes
-	Deploy DevOps tools in swarm mode via a compose file
-	Create an ephemeral environment
-	Build & deploy sample applications in Continuous Integration mode


# Prerequisists:

-	Install Docker Toolbox (Includes Git Bash, Virtual Box)
-	Install Vagrant + Vagrant-hostmanager
-	Clone this Git repository 


# Instructions:

-	Change directory to code location
-	Run "vagrant up"(This will set up the docker swarm cluster, additionally it will install infrastructure visualizer: 		"http://node1:9080")
-	Once "vagrant up" is finished, SSH into node1: "vagrant ssh node1"
-	Change directory "cd /vagrant"
-	Execute "./deployStack.sh" (This will launch a number of docker services in the docker swarm cluster created earlier. 
	These services include Jenkins, SonarQube, Nexus, two replicas of HAProxy and a proxy listener)
-	Check with visualizer ("http://node1:9080") to see if these services have been launched

The visualizer screen should look simialar to this:
![alt tag](https://github.com/shazChaudhry/techchallange/blob/master/VisualizerXXX.PNG)


# Test:

- 	Take a short break and wait until all services are started and are working
- 	Check Jenkins "http://node1/jenkins". Username: admin; Password: Password01
-	Check SonarQube "http://node1/sonar". Username: admin; Password: admin
-	Check Nexus "http://node1/nexus". Username: admin; Password: admin123


# Clean-up:
-	To remove services, execute "./removeStack.sh" in the /vagrant directory
-	To tear down the infrastructure, run "vagrant destroy"

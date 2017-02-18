# Challenge:

-	Setting up a docker swarm cluster of three nodes
-	Deploy DevOps tools in swarm mode via a compose file
-	Create an ephemeral environment
- Build & deploy sample applications in Continuous Integration mode


# Prerequisists:

-	Install Docker Toolbox (Includes Git Bash, Virtual Box)
-	Install Vagrant + Vagrant-hostmanager
-	Clone Git repository 


# Instructions:

-	Change directory to code location
-	Run "vagrant up"(This will set up the docker swarm cluster, additionally it will install infrastructure visualizer: 		"http://node1:9080")
-	Once "vagrant up" is finished, SSH into node1: "vagrant ssh node1"
-	Change directory "cd /vagrant"
-	Execute "./buildApp.sh" (This will build the sample GO code docker image). Run "docker images" to ensure "techchallange" image is available
-	Execute "./deployStack.sh" (This will launch a number of docker services in the docker swarm cluster created earlier. 
	These services include two replicas of "techchallange", Jenkins, two replicas of HAProxy and proxy listener)
-	Check with visualizer ("http://node1:9080") to see if these services have been launched

The visualizer screen should look simialar to this:
![alt tag](Visualizer.PNG)


# Test:

- 	Take a short break and wait until all services ave started and are working
- 	Check services are running "http://node1/techchallange" (Hitting "ctrl + r" should toggle between container ID's)
- 	Check Jenkins "http://node1/jenkins" Username: admin; Password: Password01


# Clean-up:
-	To remove services, execute "./removeStack.sh" in the /vagrant directory
-	To tear down the infrastructure, run "vagrant destroy"

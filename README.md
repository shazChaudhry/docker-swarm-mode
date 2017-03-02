# Demo tasks:

-	Setting up a docker swarm cluster of 4 nodes with vagrant
-	Deploy DevOps tools in swarm mode via a compose v3
- Demonstrate Jenkins Blue Ocean pipelines (auto-creating jobs via Jenkinsfile in github that checks code quality (SonarQube) and runs docker image security scanning (Anchore) 


# Prerequisists:

-	Install Docker Toolbox (Includes Git Bash, Virtual Box)
-	Install Vagrant + Vagrant-hostmanager
- Github Personal access token


# Instructions:

- Clone this github repo
-	Change to the cloned directory and run "vagrant up". This will setup a swarm cluster; 2xworkers and 2xmanagers. Furthermore this will deploy required dev tools as docker services.


The visualizer screen should look simialar to this:
![alt tag]("https://github.com/shazChaudhry/DevOps/blob/master/Physical%20architecture.PNG")


# Test Infrastructure:

- 	Take a short break and wait until all services are started
-	Visualizer is at "http://node1:9080"
- 	Check Jenkins "http://node1/jenkins". Username: admin; Password: Password01
-	Check SonarQube "http://node1/sonar". Username: admin; Password: admin
-	Check Nexus "http://node1/nexus". Username: admin; Password: admin123

# Configure Jenkins
# Configure SonarQube
# Configure Nexus
# Setup pipeline
# Test pipeline

# Clean-up:
- ssh to node4 (vagrant ssh node4)
-	To remove services, execute "docker stack rm dev"
-	To tear down the infrastructure, run "vagrant destroy"

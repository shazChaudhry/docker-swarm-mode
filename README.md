[![Build Status on Travis](https://travis-ci.org/shazChaudhry/ci-stack.svg?branch=master "CI status on Travis")](https://travis-ci.org/shazChaudhry/ci-stack)

**User story**
* As a member of DevOps team, I want to deploy DevOps tools so that project can run Coninious Integration / Delivery


![alt text](pics/logical.PNG "Swam cluster")

**Prerequisite**
* Set up an environment based on docker swarm mode

**Instructions:**
* Log into the master node in the Docker Swarm cluster
* Clone this repository and change directory to where repo is cloned to
* Deploy stack by run the following command:
  * `docker stack deploy -c docker-compose.yml ci`
* Check status of the stack services by running the following command:
  *   `docker stack services ci`
* In your favorite web browser navigate to <a href="http://node1:9080/">http://node1:9080/</a>. This Visualizer will show all services running in the swarm mode.
* Once all services are up and running, proceed to testing

**Test:**
* <a href="http://node1/jenkins"/>http://node1/jenkins</a> _(Jenkins)_. Follow the setup wizard to initialize Jenkins
* <a href="http://node1/sonar"/>http://node1/sonar</a> _(SonarQube)_. Username: admin; Password: admin
* <a href="http://node1/nexus"/>http://node1/nexus</a> _(Nexus)_. Username: admin; Password: admin123

**Clean-up:**
* On the swarm master node, run the following commands to remove swarm services:
  * `docker stack rm ci`

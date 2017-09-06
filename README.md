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
  * `echo "admin" | docker secret create jenkins-user -`
  * `echo "admin" | docker secret create jenkins-pass -`
  * `docker stack deploy -c docker-compose.yml ci`
* Check status of the stack services by running the following command:
  *   `docker stack services ci`
* Once all services are up and running, proceed to testing

**Test:**
* <a href="http://node1:9080"/>http://node1:9080</a> _(Visualizer)_
* <a href="http://node1/jenkins"/>http://node1/jenkins</a> _(Jenkins)_. Username: `admin`; Password: `admin`
* <a href="http://node1/sonar"/>http://node1/sonar</a> _(SonarQube)_. Username: `admin`; Password: `admin`
* <a href="http://node1/nexus"/>http://node1/nexus</a> _(Nexus)_. Username: `admin`; Password: `admin123`
* <a href="http://node1/gitlab"/>http://node1/gitlab</a> _(Gitlab CE)_. Username: `admin@example.com`; Password: `5iveL!fe`
  * Gitlab takes a few minutes to start up

**Clean-up:**
* On the swarm master node, run the following commands to remove swarm services:
  * `docker stack rm ci`

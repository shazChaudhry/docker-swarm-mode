[![Build Status on Travis](https://travis-ci.org/shazChaudhry/ci-stack.svg?branch=master "CI status on Travis")](https://travis-ci.org/shazChaudhry/ci-stack)

**User story**
* As a member of DevOps team, I want to deploy DevOps tools so that project can run Coninious Integration / Delivery


![alt text](pics/logical.PNG "Swam cluster")

**Prerequisite**
* Set up an environment based on docker swarm mode either by running the provided Vagrantfile or follow the instructions [Docker for AWS](https://docs.docker.com/docker-for-aws/)

**Instructions:**<br/>
These insttructions are for the environment created by running the provided Vagrantfile. For the persistant storage solusion on AWS, please see the instcutions at the bottom:
* Log into the master node in the Docker Swarm cluster
* Clone this repository and change directory to where repo is cloned to
* Deploy stack by run the following command:
  * `echo "admin" | docker secret create jenkins-user -`
  * `echo "admin" | docker secret create jenkins-pass -`
  * `docker stack deploy --compose-file docker-compose.yml ci`
* Check status of the stack services by running the following command:
  *   `docker stack services ci`
* Once all services are up and running, proceed to testing

**Test:**
* <a href="http://node1:9080"/>http://node1:9080</a> _(Visualizer)_
* <a href="http://node1/jenkins"/>http://node1/jenkins</a> _(Jenkins)_. admin username: `admin`; Password: `admin`
* <a href="http://node1/sonar"/>http://node1/sonar</a> _(SonarQube)_. admin username: `admin`; Password: `admin`
* <a href="http://node1/nexus"/>http://node1/nexus</a> _(Nexus)_. admin username: `admin`; Password: `admin123`
* <a href="http://node1/gitlab"/>http://node1/gitlab</a> _(Gitlab CE)_. admin username: `admin@example.com`; Password: `5iveL!fe`
  * Gitlab takes a few minutes to start up

**Clean-up:**
* On the swarm master node, run the following commands to remove swarm services:
  * `docker stack rm ci`

**Docker for AWS persistent data volumes** <br/>
In swarm mode, only a single Compose file is accepted. If your configuration is split between multiple Compose files, e.g. a base configuration and environment-specific overrides, you can combine these by passing them to docker-compose config with the -f option and redirecting the merged output into a new file.

Clone this repo and change directory: <br/>
1. `alias git='docker run -it --rm --name git -v $PWD:/git -w /git indiehosters/git git'`
2. `git version`
3. `git clone https://github.com/shazChaudhry/ci-stack.git`
4. `sudo chown -R docker ci-stack`
5. `cd ci-stack`

Combine both the base and environment specific compose files:<br/> 
1. `alias docker-compose='docker run --interactive --tty --rm --name docker-compose --volume $PWD:/compose --workdir /compose docker/compose:1.16.1'`
2. `docker-compose version`
3. `docker-compose -f docker-compose.yml -f docker-compose.AWS.yml config > docker-stack.yml`

Run the combined stack:<br/>
1. `echo "admin" | docker secret create jenkins-user -`
2. `echo "admin" | docker secret create jenkins-pass -`
3. `docker stack deploy --compose-file docker-stack.yml ci`
  - It appears that there are multiple bugs when combining multiple compose files. The above _"stack deploy"_ does not work and throws this error: `yaml: control characters are not allowed`
    - _SOLUTION 1:-_ Open the generated "docker-stack.yml" file and deleted the first line starting with a WARNING
    - _SOLUTION 2:-_ Ensure that the source path for settings.xml file mounted into jenkins' home directory is correct in the generated file 

Clean up:<br/>
1. `docker stack rm ci`
2. `swarm-exec docker system prune --volumes -af`

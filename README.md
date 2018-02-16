[![Build Status on Travis](https://travis-ci.org/shazChaudhry/docker-swam-mode.svg?branch=master "CI status on Travis")](https://travis-ci.org/shazChaudhry/docker-swam-mode)

### User story
As a member of DevOps team, I want to stand up DevOps tools _(Platform as Code)_ so that projects can run Coninious Integration / Delivery

![alt text](pics/CI_Stack.jpg "Swarm cluster")

### Prerequisite
Docker swarm mode environment is required
- Use provided `Vagrantfile` if you are unable to run Docker CE natively on a local machine
- *OR* see [Docker on AWS](https://docs.docker.com/docker-for-aws/) documentation on how to create a Docker swarm cluster on AWS

### Deploy CI stack in a Virtual Box with provided Vagrantfile
The **assumption** here is that Vagrant, Virtual Box and Gitbash are already install on your machine
* Log into the master node in the Docker Swarm mode cluster `vagrant ssh`
* Clone this repository `git clone https://github.com/shazChaudhry/docker-swarm-mode.git`
* Change directory `cd docker-swarm-mode`
* Deploy stack by run the following commands which will utilize [Docker secrets](https://docs.docker.com/engine/swarm/secrets/)
    ```
    echo "admin" | docker secret create jenkins-user -
    echo "admin" | docker secret create jenkins-pass -
    docker stack deploy --compose-file docker-compose.yml ci
    ```
* Check status of the stack services by running the following command:
  * `docker stack services ci`
* Once all services are up and running, proceed to testing

#### Test
* <a href="http://node1:9999"/>http://node1:9999</a> _(Visualizer)_
* <a href="http://node1/jenkins"/>http://node1/jenkins</a> _(Jenkins)_. admin username: `admin`; Password: `admin`
* <a href="http://node1/sonar"/>http://node1/sonar</a> _(SonarQube)_. admin username: `admin`; Password: `admin`
* <a href="http://node1/nexus"/>http://node1/nexus</a> _(Nexus)_. admin username: `admin`; Password: `admin123`
* <a href="http://node1/gitlab"/>http://node1/gitlab</a> _(Gitlab CE)_. admin username: `admin@example.com`; Password: `5iveL!fe`
  * Gitlab takes a few minutes to become available so please be a little patient :)

#### Clean-up
On the swarm master node, run the following commands:
* `docker stack rm ci` to remove the stack
* `exit` to exit the Virtual Box
* `vagrant destroy` to destroy the VMs

### Deploy CI stack on "Docker for AWS"
It is assumed you have followed [Docker for AWS](https://docs.docker.com/docker-for-aws/) documentation to create a new VPC. Follow these commands in an ssh client to log into your master node _(I'm using gitbash)_.

**Please** note you can not ssh directly into worker nodes. You have to use a manager node as a jump box
```
  eval $(ssh-agent) OR exec ssh-agent bash
  ssh-add -k ~/.ssh/personal.pem
  ssh-add -L
  ssh -A docker@<Manager Public IP>
  cat /etc/*-release
  docker node ls
  ```

Note:
> If Jenkins in this stack is unable to run sibling containers, set appropriate permission: `sudo setfacl -m u:1000:rw /var/run/docker.sock` on all nodes. If this command fails then a workround is `sudo chmod 666 /var/run/docker.sock` on all nodes

Clone this repo and change directory by following these commands
```
  alias git='docker run -it --rm --name git -v $PWD:/git -w /git indiehosters/git git'
  git version
  git clone https://github.com/shazChaudhry/docker-swarm-mode.git
  sudo chown -R $USER docker-swam-mode
  cd docker-swam-mode
  ```

Start the visualizer by running:
- `docker stack deploy -c docker-compose.visualizer.yml visualizer`

In a Docker swarm mode, only a single Compose file is accepted. If your configuration is split between multiple Compose files, e.g. a base configuration and environment-specific overrides, you can combine these by passing them to docker-compose config with the -f option and redirecting the merged output into a new file.
```
  alias docker-compose='docker run --interactive --tty --rm --name docker-compose --volume $PWD:/compose --workdir /compose docker/compose:1.16.1'
  docker-compose version
  docker-compose -f docker-compose.yml -f docker-compose.AWS.cloudstor.yml config > docker-stack.yml
  ```

You may be interested in knowing that the generated stack defines a volume plugin called [Cloudstor](https://docs.docker.com/docker-for-aws/persistent-data-volumes/). Docker containers can use a volume created with Cloudstor _(available across entire cluster)_ to mount a persistent data volume

 Run the combined stack
```
  echo "admin" | docker secret create jenkins-user -
  echo "admin" | docker secret create jenkins-pass -
  docker stack deploy --compose-file docker-stack.yml ci
  ```
If in case the above _"stack deploy"_ does not work and throws an error like `yaml: control characters are not allowed`
- _SOLUTION 1:-_ Open the generated "docker-stack.yml" file and delete the first line starting with a WARNING
- _SOLUTION 2:-_ Ensure that the source path for settings.xml file mounted into jenkins' container is correct

#### Test
* http://[DefaultDNSTarget]:9999 _(Visualizer)_
* http://[DefaultDNSTarget]/jenkins _(Jenkins)_. admin username: `admin`; Password: `admin`
* http://[DefaultDNSTarget]/sonar> _(SonarQube)_. admin username: `admin`; Password: `admin`
* http://[DefaultDNSTarget]/nexus _(Nexus)_. admin username: `admin`; Password: `admin123`
* http://[DefaultDNSTarget]/gitlab _(Gitlab CE)_. admin username: `admin@example.com`; Password: `5iveL!fe`
  * Gitlab takes a few minutes to become available so please be a little patient :)
  * You find [DefaultDNSTarget] on the CloudFormation page on the Outputs tab

#### Clean up
1. `docker stack rm ci`
2. `swarm-exec docker system prune --volumes -a`
3. Before deleting a Docker4AWS stack through CloudFormation, you should remove all relocatable Cloudstor volumes using docker volume rm from within the stack. EBS volumes corresponding to relocatable Cloudstor volumes are not automatically deleted as part of the CloudFormation stack deletion

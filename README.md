[![Build Status on Travis](https://travis-ci.org/shazChaudhry/docker-swarm-mode.svg?branch=master)](https://travis-ci.org/shazChaudhry/docker-swarm-mode)

### User story
As a member of DevOps team, I want to stand up DevOps tools _(Platform as Code)_ so that projects can run Coninious Integration / Coninious Delivery (CI / CD) pipelines:
* `Flow Proxy` - The goal of the [Docker Flow Proxy project](https://github.com/docker-flow/docker-flow-proxy) is to provide an easy way to reconfigure proxy every time a new service is deployed, or when a service is scaled. It does not try to "reinvent the wheel", but to leverage the existing leaders and combine them through an easy to use integration. It uses HAProxy as a proxy and adds custom logic that allows on-demand reconfiguration.
* `Flow Swarm Listener` - The goal of the [Docker Flow Swarm Listener project](https://github.com/docker-flow/docker-flow-swarm-listener) is to listen to Docker Swarm events and send requests when a change occurs. At the moment, the only supported option is to send a notification when a new service is created, or an existing service was removed from the cluster.
* `Sonatype Nexus Repository Manager 3` - Based on CentOS, a free [binary repository manager](https://github.com/sonatype/docker-nexus3) with universal support for popular repository formats such as maven, yum, raw, docker and many other
* `SonarQube` - [SonarQube](https://github.com/SonarSource/sonarqube) provides the capability to not only show health of an application but also to highlight issues newly introduced. With a Quality Gate in place, you can fix the leak and therefore improve code quality systematically
* `Jenkins` - As an extensible automation server, [Jenkins](https://hub.docker.com/r/jenkinsci/blueocean/) can be used as a simple CI server or turned into the continuous delivery hub for any project
* `GitLab Community Edition (CE)` -  [Gitlab](https://github.com/sameersbn/docker-gitlab) is an open source end-to-end software development platform with built-in version control, issue tracking, code review, CI/CD, and more. Self-host GitLab CE on your own servers

![Swarm cluster](pics/CI_Stack.jpg "Swarm cluster")

The architecture of this stack is such that all services are behind an HTTP(S) & SSH reverse proxy; single point of entry. This reverse proxy in this case is started with self signed certificate _(See ./certs/README.md)_ using docker secrets

### Prerequisite
Docker swarm mode environment is required
- Use provided `Vagrantfile` if you are unable to run Docker CE natively on a local machine.
- *OR* see [Docker for AWS](https://docs.docker.com/docker-for-aws/) documentation on how to create a Docker swarm cluster on AWS

# Deploy CI stack in a VirtualBox with provided Vagrantfile
The **assumption** here is that Vagrant, VirtualBox and Gitbash are already install on your machine _(my development environment was a Windows 10 Pro machine)_

Execute the following commands, in gitbash, in order to create a two-node docker swarm mode cluster. The nodes are based on 'ubuntu/xenial64' VM. Once the cluster is created successfully, log in to the master node:
 - `git clone https://github.com/shazChaudhry/docker-swarm-mode.git`
 - `cd docker-swarm-mode`
 - `vagrant up`
 - `vagrant ssh node1` _(Log in to the master node)_
 - `docker node ls` _(confirm that there are two nodes in the cluster; master and worker)_
 - `cd /vagrant`

Deploy stack by running the following commands which will utilize [Docker secrets](https://docs.docker.com/engine/swarm/secrets/) for Jenkins and proxy.
  * Jenkins secrets are defined in the "./secrets/jenkins" directory
  * Proxy's secrets are defined in the "./certs" directory
  ```
  docker stack deploy --compose-file docker-compose.portainer.yml portainer
  docker stack deploy --compose-file docker-compose.yml ci
  ```
* Check status of the stack services by running the following command:
  ```
  docker stack services ci
  ```
* Once all services are up and running, proceed to the next step

#### Service URLs
* <a href="http://node1:9000"/>http://node1:9000</a> _(Portainer)_
* <a href="https://node1/jenkins"/>https://node1/jenkins</a> _(Jenkins)_. admin username: `admin`; Password: `admin`
* <a href="https://node1/sonar"/>https://node1/sonar</a> _(SonarQube)_. admin username: `admin`; Password: `admin`
* <a href="https://node1/nexus"/>https://node1/nexus</a> _(Nexus)_. admin username: `admin`; Password: `admin123`
  * Follow these instructions to setup docker registries; at least one should be of type proxy and should point to docker hub: https://help.sonatype.com/repomanager3/private-registry-for-docker/proxy-repository-for-docker
  * Reserve _"8082"_ for docker group repo
  * Reserve _"5000"_ docker hosted repo
* <a href="https://node1/gitlab"/>https://node1/gitlab</a> _(Gitlab CE)_. admin username: `root`; Password: `Password01`
  * Gitlab takes a few minutes to become available so please be a little patient :)
  * You can also view service logs, `docker service logs -f ci_gitlab`, to check when gitlab becomes available

#### Cloning repositories with HTTPS
This is assuming you already have imported some repositories into gitlab or have created your own repos:
* ```git config --global http.sslVerify false``` _(Turns off Git SSL Verification for a non trusted server certificate. Otherwise, you may receive 'SSL certificate problem: self signed certificate' error)_
* ```git clone https://root:Password01@node1/gitlab/[GROUP_NAME]/[REPOSITORY_NAME].git```

#### Cloning repositories with SSH
This is assuming you have already uploaded your ssh public key to gitlab:
* ```git clone ssh://git@node1:10022/[GROUP_NAME]/[REPOSITORY_NAME].git```


#### Clean-up
On the swarm master node, run the following commands:
* `docker stack rm ci` to remove the stack
* `exit` to exit the vagrant box
* `vagrant destroy --force` to destroy the VMs

# Deploy CI stack on "Docker for AWS"
It is assumed you have followed [Docker for AWS](https://docs.docker.com/docker-for-aws/) documentation to create a new VPC. Follow these commands in an ssh client to log in to your master node _(I'm using gitbash on Windows 10 Pro)_.

**Please** note you can not ssh directly into worker nodes. You have to use a manager node as a jump box
- `eval $(ssh-agent) OR exec ssh-agent bash`
- `ssh-add -k ~/.ssh/personal.pem` _(You wiill have to use your own key)_
- `ssh-add -L`
- `ssh -A docker@<Manager Public IP>`
- `cat /etc/*-release`
- `docker node ls`

Clone this repo and change directory by following these commands:
- `alias git='docker run -it --rm --name git -v $PWD:/git -w /git alpine/git'` _(This alias is only required if git is not already installed on your machine. This alias will allow you to clone the repo using a git container)_
- `git version`
- `git clone https://github.com/shazChaudhry/docker-swarm-mode.git`
- `sudo chown -R $USER:$USER docker-swarm-mode`
- `cd docker-swarm-mode`

Start the Portainer by running:
- `docker stack deploy -c docker-compose.portainer.yml portainer`

Notes:
> In a Docker swarm mode, only a single Compose file is accepted. If your configuration is split between multiple Compose files, e.g. a base configuration and environment-specific overrides, you can combine these by passing them to docker-compose config with the -f option and redirecting the merged output into a new file.

> These instructions are only needed if files to be merged have been edited / updated for any reason. For your info, a default "docker-stack.yml" has already been generated and is ready to be used
- `alias docker-compose='docker run --interactive --tty --rm --name docker-compose --volume $PWD:/compose --workdir /compose docker/compose:1.23.1'`
- `docker-compose version`
- `docker-compose -f docker-compose.yml -f docker-compose.AWS.cloudstor.yml config > docker-stack.yml`

Note:
> If you did have to generate a new `docker-stack.yml` file above then ensure you follow the instructions below before launching the platform stack
- Open the generated "docker-stack.yml" file, address WARNINGS _(top two lines)_ and then delete WARNING lines
  - Ensure that the source path for settings.xml file mounted into jenkins' container is correct i.e. $PWD is not missing
  - Ensure that the source path for secret files is correct i.e. $PWD is not missing

 Run the combined stack. Please note that secrets are defined in ./secrets/jenkins and ./certs directories in this repo:
 - `export DefaultDNSTarget=<<find this value on your CloudFormation page in AWS console>>`
 - `docker stack deploy --compose-file docker-stack.yml ci` You may be interested in knowing that this stack defines a volume plugin called [Cloudstor](https://docs.docker.com/docker-for-aws/persistent-data-volumes/). Docker containers can use a volume created with Cloudstor _(available across entire cluster)_ to mount a persistent data volume
 - `docker stack services ci`

 Note:
 > If Jenkins in this stack is unable to run sibling containers, set appropriate permission: `sudo setfacl -m u:1000:rw /var/run/docker.sock` on all nodes. If this command fails then a workround is - `sudo chmod 666 /var/run/docker.sock` on all nodes

#### Service URLs
* http://[DefaultDNSTarget]:9000 _(Portainer)_
* https://[DefaultDNSTarget]/jenkins _(Jenkins)_. admin username: `admin`; Password: `admin`
* https://[DefaultDNSTarget]/sonar> _(SonarQube)_. admin username: `admin`; Password: `admin`
  * Install / uninstall plugins as required by going to "Administration -> Marketplace" section
* https://[DefaultDNSTarget]/nexus _(Nexus)_. admin username: `admin`; Password: `admin123`
  * Follow these instructions to setup docker registries; at least one should be of type proxy and should point to docker hub: https://help.sonatype.com/repomanager3/private-registry-for-docker/proxy-repository-for-docker
  * Reserve _"8082"_ for docker group repo
  * Reserve _"5000"_ docker hosted repo
* https://[DefaultDNSTarget]/gitlab _(Gitlab CE)_. admin username: `root`; Password: `Password01`
  * Gitlab takes a few minutes to become available so please be a little patient :)

#### Configuring your clinet for interacting with docker repos in Nexus
* You will need to look up docker daemon documentation for your system. This was tested on ubuntu/xenial64.
* Create a file `/etc/docker/daemon.json` and copy the following content in that file
  ```
  {
  "insecure-registries": [
    "[DefaultDNSTarget]:443",
    "[DefaultDNSTarget]:5000"
  ],
  "disable-legacy-registry": true
  }
  ```
* You have to restart the daemon after setting this `sudo systemctl restart docker`
* `docker login -u admin -p admin123 [DefaultDNSTarget]:443` This should be successful and then you should be able to pull images from docker group repo i.e. `docker image pull [DefaultDNSTarget]:443/hello-world:latest`
* `docker login -u admin -p admin123 [DefaultDNSTarget]:5000` This should be successful and then you should be able to push images to your nexus hosted repo i.e. `docker image push [DefaultDNSTarget]:5000/hello-world:latest`

#### Cloning repositories with SSH
This is assuming your ssh public key has already been uploaded to gitlab:
* ```git clone ssh://git@[DefaultDNSTarget]:10022/[GROUP_NAME]/[REPOSITORY_NAME].git```

#### Cloning repositories with HTTPS
This is assuming you already have imported some repositories into gitlab or have created your own repos:
* ```git config --global http.sslVerify false``` _(Turns off Git SSL Verification for a non trusted server certificate. Otherwise, you may receive 'SSL certificate problem: self signed certificate' error)_
* ```git clone https://root:Password01@[DefaultDNSTarget]/gitlab/[GROUP_NAME]/[REPOSITORY_NAME].git``` _(username & password will be required if repositories are private)_

#### Clean up
1. `docker stack rm ci`
2. `swarm-exec docker system prune --volumes -af`
3. Before deleting a Docker4AWS stack through CloudFormation, you should remove all relocatable Cloudstor volumes using docker volume rm from within the stack. EBS volumes corresponding to relocatable Cloudstor volumes are not automatically deleted as part of the CloudFormation stack deletion

# Setup [Jenkins declarative](https://jenkins.io/doc/book/pipeline/syntax) pipeline
Steps to setting up this pipeline should be identical regardless of the deployment methods shown above; Local or AWS
- In the GitLab instance, import [spring-petclinic](https://github.com/shazChaudhry/spring-petclinic) project from GitHub: https://github.com/shazChaudhry/spring-petclinic ![alt text](pics/spring-petclinic.PNG "Spring Petclinic")
- In the Jenkins instance, create a new Blue Ocean pipeline project:
  - Where do you store your code? = `Git` _(Keep an eye on the [support for Gitlab](https://jenkins.io/projects/blueocean/roadmap/) in Blue Ocean. At the time of writing this, the plugin was still in planned phase)_
  - Repository URL = `ssh://git@gitlab:22/java/spring-petclinic.git` ![alt text](pics/create-pipeline.PNG "Create Pipeline")
- When informed to register the public SSH key with your Git server to continue, copy the generated key
- In the GitLab servicer, go to "Admin area -> Deploy Keys". And then paste the key ![alt text](pics/admin-deploy-keys.PNG "Admin Deloy Keys")
- Once "Deloy Key" has been created, head over to the "spring-petclinic" project in GitLab
- Go to "Settings -> Repository" and then expand the Deploy Keys section. Ensure that you enable the deploy key at the bottom of the page ![alt text](pics/project-deploy-keys.PNG "Enable Project Deloy Keys")
- Now, in Jenkins, click on the "Create pipeline". A job in jenkins will be created which then will:
  - Build maven packages using Nexus maven repos
  - Run static code analysis and publish report on SonarQube instance
  - Inform GitLab of the build status

After a successful build, a pipeline should look like this: ![alt text](pics/Jenkins-pipeline.PNG "Jenkins Blue Ocean pipeline")

After a successful build, maven build artifacts should be deployed in maven snapshot repository: ![alt text](pics/maven-snapshot-repo.PNG "Maven Snapshot Repository")

After a successful build, SonarQube reports should be available: ![alt text](pics/sonarqube.PNG "SonarQube Report")

pipeline {
	agent {
		docker {
			image 'maven'
		}
	}
	stages {
		stage('SCM') {
			steps {
				deleteDir()
				git 'https://github.com/spring-projects/spring-petclinic.git'
			}
		}
		stage('Build Code') {
			steps {
				sh 'mvn -Dmaven.test.failure.ignore=true --settings /var/jenkins_home/settings-docker.xml clean package'
				junit(allowEmptyResults: true, testResults: 'target/surefire-reports/*.xml')
				archiveArtifacts(artifacts: 'target/*.jar', fingerprint: true, onlyIfSuccessful: true, defaultExcludes: true)
			}
		}
		stage('Code quality gate') {
			steps {
				sh 'mvn --settings /var/jenkins_home/settings-docker.xml sonar:sonar'
			}
		}
	}
	options {
		buildDiscarder(logRotator(numToKeepStr: '5'))
	}
}

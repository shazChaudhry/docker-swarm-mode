pipeline {
	/* insert Declarative Pipeline here */
	
	agent none	
	
	options {
    		// Keep the 10 most recent builds
    		buildDiscarder(logRotator(numToKeepStr:'5')) 
  	}
	
    	stages {
	    
        	stage('Build') {
			agent {
    				docker {
     			 		image 'maven'
    				}
  			}
            		steps {
                		sh 'mvn -Dmaven.test.failure.ignore=true clean package'
				junit(testResults: 'target/surefire-reports/*.xml', allowEmptyResults: true)
				archiveArtifacts artifacts: '**/target/*.jar', fingerprint: true
            		}
       		 }
	    
        	stage('Code Quality') {
			agent {	docker 'maven' }
            		steps {
				sh 'mvn sonar:sonar -Dsonar.host.url=http://node1/sonar'
           		 }
        	}
	    
        	stage('Build image') {
			agent any
            		steps {
                		sh 'docker build -t simple-junit .'
           		 }			
        	}
	    
        	stage('Scan image') {
			agent any
            		steps {
                		sh 'docker pull anchore/cli'
                		sh 'docker run -d -v /var/run/docker.sock:/var/run/docker.sock --name anchore anchore/cli'
                		sh 'docker exec anchore anchore feeds sync'
                		sh 'docker exec anchore anchore analyze --image simple-junit --imagetype base'
				sh 'docker exec anchore anchore query --image simple-junit cve-scan all'
           		 }			
        	}
	    
        	stage('Test image') {
			agent any
            		steps {
				echo '================================='
                		sh 'docker run --rm simple-junit'
				echo '================================='
           		 }			
        	}
	}
  	    
	post {
		always {
			echo 'This will always run'
			sh 'docker stop anchore'
			sh 'docker rm anchore'
		}
		success {
		    	echo 'This will run only if successful'
		}
		failure {
		    	echo 'This will run only if failed'
		}
		unstable {
		    	echo 'This will run only if the run was marked as unstable'
		}
		changed {
		    	echo 'This will run only if the state of the Pipeline has changed'
		    	echo 'For example, the Pipeline was previously failing but is now successful'
		}
    }
}

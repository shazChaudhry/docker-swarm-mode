pipeline {
	/* insert Declarative Pipeline here */
	
	agent any	
	
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
            		steps {
                		sh 'docker build -t simple-junit .'
           		 }			
        	}
	    
        	stage('Test') {
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

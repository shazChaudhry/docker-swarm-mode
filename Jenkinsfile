pipeline {
	
	agent {
    		// Use docker container
    		docker {
     			 image 'maven'
    		}
  	}	
	
	options {
    		// Keep the 10 most recent builds
    		buildDiscarder(logRotator(numToKeepStr:'10')) 
  	}
	
    	stages {
	    
        	stage('build') {
            		steps {
                		sh 'mvn -Dmaven.test.failure.ignore=true clean package'
				junit(testResults: 'target/surefire-reports/**/*.xml', allowEmptyResults: true)
				archiveArtifacts artifacts: '**/target/*.jar', fingerprint: true
            		}
       		 }
	    
        	stage('sonar') {
            		steps {
                		sh 'mvn sonar:sonar -Dsonar.host.url=http://node1/sonar'
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

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
  
}

pipeline {
	agent { docker 'maven' }
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

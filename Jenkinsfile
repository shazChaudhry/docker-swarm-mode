pipeline {
    agent { docker 'maven' }
    stages {
	    
        stage('build') {
            steps {
                sh 'mvn clean package'
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

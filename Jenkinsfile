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
	    
	post {
		always {
		    sh 'This will always run'
		}
		success {
		    sh 'This will run only if successful'
		}
		failure {
		    sh 'This will run only if failed'
		}
		unstable {
		    sh 'This will run only if the run was marked as unstable'
		}
		changed {
		    sh 'This will run only if the state of the Pipeline has changed')
		    sh 'For example, the Pipeline was previously failing but is now successful'
		}
    	}
    }
}

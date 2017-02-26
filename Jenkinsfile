pipeline {
    agent { docker 'maven' }
    stages {
        stage('build') {
            steps {
                sh 'mvn clean package'
            }
        }
        stage('sonar') {
            steps {
                sh 'mvn sonar:sonar -Dsonar.host.url=http://sonarqube:9000'
            }
        }
        stage('create_image') {
			agent { docker 'docker' }
            steps {
                echo 'Creatge Image'
            }
        }
        stage('scan_image') {
			agent { docker 'docker' }
            steps {
                echo 'Creatge Image'
            }
        }
    }
}

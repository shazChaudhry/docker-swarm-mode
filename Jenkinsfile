pipeline {
  agent none
  stages {
    stage('Build Code') {
      agent {
        docker {
          image 'maven'
        }
        
      }
      steps {
        sh 'mvn --global-settings maven/settings.xml -Dmaven.test.failure.ignore=true clean package'
        junit(testResults: 'target/surefire-reports/*.xml', allowEmptyResults: true)
        archiveArtifacts(artifacts: '**/target/*.jar', fingerprint: true)
      }
    }
    stage('Code Quality') {
      agent {
        docker 'maven'
      }
      steps {
        sh 'mvn --global-settings maven/settings.xml sonar:sonar'
      }
    }
    stage('Build image') {
      agent any
      steps {
        sh '''echo ${WORKSPACE}
pwd
docker build -t simple-junit java'''
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
        sh 'docker stop anchore'
        sh 'docker rm anchore'
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
  options {
    buildDiscarder(logRotator(numToKeepStr: '5'))
  }
}
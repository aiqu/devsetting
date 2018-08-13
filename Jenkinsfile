pipeline {
  agent any
  environment {
    MSG_PREFIX = "${env.JOB_NAME} - ${env.BUILD_DISPLAY_NAME}"
    MSG_LINK = "(<${env.BUILD_URL}|Open>)"
    DOCKER_BUILD_OPTION="--force-rm --no-cache --pull"
  }
  stages {
    stage('pre-build') {
      steps {
        slackSend(message: "${MSG_PREFIX} started ${MSG_LINK}", failOnError: true, color: 'good')
      }
    }
    stage('base & jenkins') {
      failFast true
      parallel {
        stage ("base:latest") {
          steps {
            sh '''
              sudo docker build -t gwangmin/base:latest -f dockerfiles/base --build-arg BASEIMG=centos7_dev ${DOCKER_BUILD_OPTION} .
              sudo docker push gwangmin/base:latest
              '''
          }
        }
        stage ("base:gcc7") {
          steps {
            sh '''
              sudo docker build -t gwangmin/base:gcc7 -f dockerfiles/base --build-arg BASEIMG=centos7_gcc7 ${DOCKER_BUILD_OPTION} .
              sudo docker push gwangmin/base:gcc7
              '''
          }
        }
      }
    }
  }
  post {
    success {
      slackSend(message: "${MSG_PREFIX} finished ${MSG_LINK}", failOnError: true, color: 'good')
    }
    failure {
      slackSend(message: "${MSG_PREFIX} failed ${MSG_LINK}", failOnError: true, color: 'danger')
    }
  }
}

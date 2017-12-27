pipeline {
  agent any
  stages {
    stage('pre-build') {
        steps {
        slackSend(message: "${env.JOB_NAME} - ${env.BUILD_DISPLAY_NAME} started (<${env.BUILD_URL}|Open>)", failOnError: true, color: 'good')
        stash name: 'source'
        }
    }
    stage('base & jenkins') {
      steps {
          parallel (
              "base:latest" : {
                  node('slave') {
                    unstash 'source'
                    sh '''
                        sudo docker build -t gwangmin/base:latest -f dockerfiles/base --build-arg BASEIMG=centos_7_dev ${DOCKER_BUILD_OPTION} .
                        sudo docker push gwangmin/base:latest
                    '''
                    }
                },
              "base:gcc7" : {
                  node('slave') {
                    unstash 'source'
                    sh '''
                        sudo docker build -t gwangmin/base:gcc7 -f dockerfiles/base --build-arg BASEIMG=centos_7_gcc_7 ${DOCKER_BUILD_OPTION} .
                        sudo docker push gwangmin/base:gcc7
                    '''
                    }
                },
          )
      }
    }
  }
  environment {
    MSG_PREFIX = "${env.JOB_NAME} - ${env.BUILD_DISPLAY_NAME}"
    MSG_LINK = "(<${env.BUILD_URL}|Open>)"
    DOCKER_BUILD_OPTION="--force-rm --no-cache --pull"
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

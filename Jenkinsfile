pipeline {
  agent any
  stages {
    stage('centos_7_dev') {
      steps {
        slackSend(message: "${env.JOB_NAME} - ${env.BUILD_DISPLAY_NAME} started (<${env.BUILD_URL}|Open>)", failOnError: true, color: 'good')
        sh '''
            if [ ! -z "$(git diff --name-only @~1 | grep centos_7_dev)" ];
            then
                docker build -t gwangmin/centos_7_dev:latest -f dockerfiles/centos_7_dev ${DOCKER_BUILD_OPTION} .
                docker push gwangmin/centos_7_dev:latest
            fi
        '''
      }
    }
    stage('centos_7_gcc_7') {
      steps {
        sh '''
            if [ ! -z "$(git diff --name-only @~1 | grep centos_7)" ];
            then
                docker build -t gwangmin/centos_7_gcc_7:latest -f dockerfiles/centos_7_gcc_7 ${DOCKER_BUILD_OPTION} .
                docker push gwangmin/centos_7_gcc_7:latest
            fi
        '''
      }
    }
    stage('base & jenkins') {
      steps {
          parallel (
              "base:latest" : {
                  node() {
                    sh '''
                        docker build -t gwangmin/base:latest -f dockerfiles/base --build-arg BASEIMG=centos_7_dev ${DOCKER_BUILD_OPTION} .
                        docker push gwangmin/base:latest
                    '''
                    }
                },
              "base:gcc7" : {
                  node() {
                    sh '''
                        docker build -t gwangmin/base:gcc7 -f dockerfiles/base --build-arg BASEIMG=centos_7_gcc_7 ${DOCKER_BUILD_OPTION} .
                        docker push gwangmin/base:gcc7
                    '''
                    }
                },
              "jenkins_did" : {
                  node() {
                    sh '''
                        if [ ! -z "$(git diff --name-only @~1 | grep dockerfiles/jenkins_did)" ];
                        then
                            docker build -t gwangmin/jenkins_did:latest -f dockerfiles/jenkins_did ${DOCKER_BUILD_OPTION} .
                            docker push gwangmin/jenkins_did:latest
                        fi
                    '''
                    }
                },
              "jenkins_did" : {
                  node() {
                    sh '''
                        if [ ! -z "$(git diff --name-only @~1 | grep dockerfiles/jenkins_slave_did)" ];
                        then
                            docker build -t gwangmin/jenkins_slave_did:latest -f dockerfiles/jenkins_slave_did ${DOCKER_BUILD_OPTION} .
                            docker push gwangmin/jenkins_slave_did:latest
                        fi
                    '''
                    }
                }
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
    changed {
      slackSend(message: "${MSG_PREFIX} changed ${MSG_LINK}", failOnError: true, color: 'warning')
    }
    unstable {
      slackSend(message: "${MSG_PREFIX} unstable ${MSG_LINK}", failOnError: true, color: 'warning')
    }
    aborted {
      slackSend(message: "${MSG_PREFIX} aborted ${MSG_LINK}", failOnError: true, color: 'danger')
    }
  }
}

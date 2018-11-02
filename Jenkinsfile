pipeline {
  agent any
  environment {
    MSG_PREFIX = "${env.JOB_NAME} - ${env.BUILD_DISPLAY_NAME}"
    MSG_LINK = "(<${env.BUILD_URL}|Open>)"
    DOCKER_BUILD_OPTION="--force-rm --no-cache --pull"
    REG=credentials('gwangmin-dockerhub')
  }
  stages {
    stage('pre-build') {
      steps {
        slackSend(message: "${MSG_PREFIX} started ${MSG_LINK}", failOnError: true, color: 'good')
      }
    }
    stage('base') {
      failFast true
      parallel {
        stage ("base:latest") {
          steps {
            sh '''
              sudo docker login -u ${REG_USR} -p ${REG_PSW}
              sudo docker build -t gwangmin/base:latest -f dockerfiles/base --build-arg BASEIMG=centos7_dev --build-arg CFLAGS="-march=core2 -mtune=core-avx2 -O2" ${DOCKER_BUILD_OPTION} .
              sudo docker push gwangmin/base:latest
              '''
          }
        }
        stage ("base:gcc5") {
          steps {
            sh '''
              sudo docker login -u ${REG_USR} -p ${REG_PSW}
              sudo docker build -t gwangmin/base:gcc5 -f dockerfiles/base --build-arg BASEIMG=centos7_gcc5 ${DOCKER_BUILD_OPTION} .
              sudo docker push gwangmin/base:gcc5
              '''
          }
        }
        stage ("base:gcc7") {
          steps {
            sh '''
              sudo docker login -u ${REG_USR} -p ${REG_PSW}
              sudo docker build -t gwangmin/base:gcc7 -f dockerfiles/base --build-arg BASEIMG=centos7_gcc7 ${DOCKER_BUILD_OPTION} .
              sudo docker push gwangmin/base:gcc7
              '''
          }
        }
        stage ("base:gcc8") {
          steps {
            sh '''
              sudo docker login -u ${REG_USR} -p ${REG_PSW}
              sudo docker build -t gwangmin/base:gcc8 -f dockerfiles/base --build-arg BASEIMG=centos7_gcc8 ${DOCKER_BUILD_OPTION} .
              sudo docker push gwangmin/base:gcc8
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

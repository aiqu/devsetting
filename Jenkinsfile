pipeline {
  agent any
  stages {
    stage('centos_7_dev') {
      steps {
        slackSend(message: "${env.JOB_NAME} - ${env.BUILD_DISPLAY_NAME} started (<${env.BUILD_URL}|Open>)", failOnError: true, color: 'good')
        sh '''
            if [ ! -z "$(git diff --name-only @~1 | grep centos_7_dev)" ];
            then
                docker build -t gwangmin/centos_7_dev -f dockerfiles/centos_7_dev ${DOCKER_BUILD_OPTION} .
                docker push gwangmin/centos_7_dev
            fi
        '''
      }
    }
    stage('centos_7_gcc_7') {
      steps {
        sh '''
            if [ ! -z "$(git diff --name-only @~1 | grep centos_7)" ];
            then
                docker build -t gwangmin/centos_7_gcc_7 -f dockerfiles/centos_7_gcc_7 ${DOCKER_BUILD_OPTION} .
                docker push gwangmin/centos_7_gcc_7
            fi
        '''
      }
    }
    stage('base') {
      steps {
        parallel(
          "base": {
            sh '''
                docker build -t gwangmin/base -f dockerfiles/base --build-arg BASEIMG=centos_7_dev ${DOCKER_BUILD_OPTION} .
                docker build -t gwangmin/base:gcc7 -f dockerfiles/base --build-arg BASEIMG=centos_7_gcc_7 ${DOCKER_BUILD_OPTION} .
                docker push gwangmin/base
                docker push gwangmin/base:gcc7
            '''
          },
          "base_ivybridge": {
            sh '''
                docker build -t gwangmin/base:ivybridge -f dockerfiles/base --build-arg BASEIMG=centos_7_gcc_7 --build-arg CFLAGS="-march=ivybridge -O2 -pipe" ${DOCKER_BUILD_OPTION} .
                docker push gwangmin/base:ivybridge
            '''
            
          },
          "base_haswell": {
            sh '''
                docker build -t gwangmin/base:haswell -f dockerfiles/base --build-arg BASEIMG=centos_7_gcc_7 --build-arg CFLAGS="-march=haswell -O2 -pipe" ${DOCKER_BUILD_OPTION} .
                docker push gwangmin/base:haswell
            '''
            
          },
          "base_broadwell": {
            sh '''
                docker build -t gwangmin/base:broadwell -f dockerfiles/base --build-arg BASEIMG=centos_7_gcc_7 --build-arg CFLAGS="-march=broadwell -O2 -pipe" ${DOCKER_BUILD_OPTION} .
                docker push gwangmin/base:broadwell
            '''
          },
          "base_skylake": {
            sh '''
                docker build -t gwangmin/base:skylake -f dockerfiles/base --build-arg BASEIMG=centos_7_gcc_7 --build-arg CFLAGS="-march=skylake -O2 -pipe" ${DOCKER_BUILD_OPTION} .
                docker push gwangmin/base:skylake
            '''
          }
        )
      }
    }
    stage('jenkins_did') {
      steps {
        sh '''
            if [ ! -z "$(git diff --name-only @~1 | grep dockerfiles/jenkins_did)" ];
            then
                docker build -t gwangmin/jenkins_did -f dockerfiles/jenkins_did ${DOCKER_BUILD_OPTION} .
                docker push gwangmin/jenkins_did
            fi
        '''
      }
    }
  }
  environment {
    MSG_PRFIX = "${env.JOB_NAME} - ${env.BUILD_DISPLAY_NAME}"
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

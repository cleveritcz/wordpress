// Uses Declarative syntax to run commands inside a container.
pipeline {
    agent {
        kubernetes {
            yaml '''
kind: Pod
metadata:
  name: kaniko
  namespace: jenkins
spec:
  containers:
  - name: shell
    image: gcr.io/kaniko-project/executor:debug
    imagePullPolicy: IfNotPresent
    env:
     - name: container
       value: "docker"
    command:
     - /busybox/cat
    tty: true
    volumeMounts:
      - name: jenkins-docker-cfg
        mountPath: /kaniko/.docker
  volumes:
    - name: jenkins-docker-cfg
      projected:
        sources:
        - secret:
            name: regcred
            items:
              - key: .dockerconfigjson
                path: config.json
'''
            defaultContainer 'shell'
        }
    }
  stages {
    stage('Build') {    
      steps {
        container(name: 'shell') {
          sh '/kaniko/executor --dockerfile `pwd`/Dockerfile --context `pwd` --destination=cleveritcz/wordpress:latest-php$PHP_VERSION --destination=cleveritcz/wordpress:$WORDPRESS_VERSION-php$PHP_VERSION --build-arg WORDPRESS_VERSION=$WORDPRESS_VERSION --build-arg PHP_VERSION=$PHP_VERSION'
        }

      }
    }

  }
  environment {
    WORDPRESS_VERSION = '6.1.1'
    PHP_VERSION = '8.2'
  }
}

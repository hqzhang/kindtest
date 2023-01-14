
properties([
   pipelineTriggers([githubPush()]),
   parameters([
              string(name: 'Org', defaultValue: 'wavecloud', description: 'input organization'),
              string(name: 'App', defaultValue: 'nginx-openshift', description: 'input application'), 
              string(name: 'Port', defaultValue: '8081', description: 'input expose port'),
		])
])
pipeline {
    agent any
    options { timestamps () }
    environment { 
       //define global variable
       PATH="/usr/local/bin:$PATH"
       private_key='afb3704a-da55-4576-9fb9-9a6265319f2b'
       dockerCred='48bc6aae-d8cc-43ce-8eac-6d9bd209a8be'
       app='nginx-openshift'
       org='wavecloud'
       image="${org}/${app}"
       port='8081'
    }

    stages {
        stage('Stage: Build and push image'){
            steps { 
                script {
                    echo "Stage: Initial and Clean..."
                    echo "Input Parameters: ${params}"
                    withCredentials([usernamePassword(credentialsId: dockerCred, usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        sh """
                            echo "login docker"
                            docker login -u$USERNAME -p$PASSWORD

                            echo "build docker"
                            docker rm -f $app | echo "container not running"
                            docker build -f Dockerfile -t $image  . 
                         
                            echo "push docker and clean"
                            docker push $image
                            docker rmi $image

                    """
                    }
                }
            }
        }
                
        stage('Stage: Deploy docker images'){
            steps { 
                script {
                    echo "Stage: Deploy docker images..."
                  
                    //withCredentials([usernamePassword(credentialsId: dockerCred, usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh """
                        echo "deploy docker "
                        docker run --name $app -d -p $port:$port $image

                        echo "wait a whole"
                        sleep 10

                        """
                    //}
                }
            }
        }
        stage('Stage: Verification'){
            steps { 
                script {
                    echo "Stage: Verification..."
                    
                    //withCredentials([usernamePassword(credentialsId: dockerCred, usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        sh """
                          echo "verify docker"
                            if curl localhost:$port | grep 'Welcome HONGQI' ; then
                                echo "verify successfully"
                            else
                                echo "ERROR: verify failure"
                                exit 1;
                            fi

                            echo "clean docker "
                            docker rm -f $app

                         """
            //       }
                }
            }
        }


	}
}


properties([
   pipelineTriggers([githubPush()]),
   parameters([
           choice(name: 'choice1', choices: ['dev','qa','prod'], description: 'input cluster'),
           choice(name: 'ocversion', choices: ['oc-3.9.0','oc-3.10.0'], description: 'input oc version'),

					 ])
		])
pipeline {
    agent any
    
    options { timestamps () }
    environment { 
       //define global variable
       PATH="/usr/local/bin:$PATH"
       myvar='helloworld'
       private_key='afb3704a-da55-4576-9fb9-9a6265319f2b'
       dockerCred='48bc6aae-d8cc-43ce-8eac-6d9bd209a8be'
       app='nginx-openshift'
       org='wavecloud'
       image="${org}/${app}"
       port='8081'

    }

    stages {
        stage('Stage: Run Ansible Playbook'){
            steps { 
                script {
                    echo "Stage: Initial and Clean..."
                    echo "Input Parameters: ${params}"
                    withCredentials([usernamePassword(credentialsId: dockerCred, usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        sh """
                            echo "check docker"
                            docker ps

                            echo "login docker"
                            docker login -u$USERNAME -p$PASSWORD



                            echo "build docker"
                            ls -al
                            docker build -f Dockerfile -t $image . 
                         
                            echo "push docker"
                            docker push $image

                            echo "clean local one"
                            docker rmi $image

                            echo "deploy docker remotely"
                           
                            docker run --name $app -d -p $port:$port $image

                            echo "verify docker"
                            if curl localhost:$port | grep 'Welcome to nginx!' ; then
                                echo "verify successfully"
                            else
                                echo "ERROR: verify failure"
                                exit 1;
                            fi


                            """
                           }
						}
					}
				}

	}
}

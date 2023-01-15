
# How to use the repo
```
1. git clone https://github.com/hqzhang/kindtest.git
   cd kindtest
2. docker play: ./rundocker
   docker advance: ./rundoker_adv
3. kubernetes play: ./runkube
4. Jenkins play docker: 
   create Jenkins pipeline job and input https://github.com/hqzhang/kindtest.git and Jenkinsfile
5. Jenkins play kubernetes:
    create Jenkins pipeline job and input https://github.com/hqzhang/kindtest.git and Jenkinsfile-kind
```

# Devops Summary
0. [Github etc](#github-etc)
1. [VirtualBox etc](#virtualbox-etc)
2. [Nginx etc](#nginx-etc)
3. [Docker etc](#docker-etc)
4. [Kubernetes(kind) etc](#kubernetes(kind)-etc)
5. [Yaml etc](#yaml-etc)
6. [Jenkins etc](#jenkins-etc)


### Github Etc
Using Gihub, one can store his code to cloud and pull out the code from it.
```
create a github repo
1. create github account: https://github.com/

2. create github repo: https://github.com/hqzhang/cloudtestbed.git

install git client
3. install gitbash(windows) or git(mac/linux):https://git-scm.com/downloads

generate ssh key pair(id_rsa&id_rsa.pub)
4. generate ssh key :ssh-keygen -t rsa -b 4096 -C
set pub key to github
5. copy ~/.ssh/id_rsa.pub to github account

6. git clone repo
  git clone git@github.com:hqzhang/cloudtestbed.git

download and modify repo 
7. git checkout -b new-branch
8. modify existing file
9. git add -u .
10. git commit -m "first change"
11. git push -u origin new-branch

create pull request and merge to main
12. create pull request in github
13. review code and merge in github

14. end
```
### VirtualBox Etc
Using VirtualBox, one can setup any kind of Operating System(Win/Mac/Linux) in your machine(Win/Mac/Linux)
```
1. install virtualbox on host 
   https://download.virtualbox.org/virtualbox/7.0.4/VirtualBox-7.0.4-154605-Win.exe
2. download centos-7 iso
   https://ftp.riken.jp/Linux/centos/7/isos/x86_64/CentOS-7-x86_64-Minimal-2009.iso

create centos7 virtual machine
3. open virtualbox and new a centos7 machine: put centos7 iso file
4. set centos7 password and install it.

set centos7 networking
5. in virtualbox setting--network: add bridge and host-only adaptor
6. restart centos7 and change /etc/sysconfig/network-scripts/ifcfg-enp0s3: onboot=Yes
7. restart centos7 and ip come out

access centos7 virtual machine
8. on gitbash , ssh root@192.168.2.102 input pass
9. mkdir .ssh and put id_rsa.pub into file: authorized_keys
10.then ssh root@192.168.2.102 directly no need pass

11. end
```
###  Nginx etc
Using Nginx, Website can holding html files while Appsite can holding java war file using tomcat.
```
Using github hold html file
1. create index.html and push to repo https://github.com/hqzhang/welcom

<html>
 <head>
 </head>
 <body>
   <h1>Hello Emily<h1>
 </body>
</html>

2. open repo setting and click pages
  https://github.com/hqzhang/welcom/settings/pages

3. verify the website ready
  https://hqzhang.github.io/welcom/

Using nginx hold html
4. install nginx
   sudo yum install epel-release
   sudo yum install nginx
   
5. modify /usr/share/nginx/html/index.html
   sed -i.bak -e 's/Welcome/Welcome HONGQI/' /usr/share/nginx/html/index.html

6. modify config
   sed -i.bak -e 's/listen\( *\)80;/listen 8081;/' -e 's/listen\(.*\)80;//' /etc/nginx/conf.d/default.conf #change listening port
   sed -i.bak 's/^user/#user/' /etc/nginx/nginx.conf. #comment user

7. restart nginx
   sudo systemctl start nginx
8. verify the websie ready
  http://localhost:8081

9. end
```
### Docker Etc
Using Docker make application install easier compare with host installation.
```
install docker daemon
1. sudo yum check-update on Centos7 machine
2. curl -fsSL https://get.docker.com/ | sh

start docker daemon
3. sudo systemctl start docker
4. sudo systemctl status docker
5. sudo systemctl enable docker

set docker command without sudo
6. sudo usermod -aG docker $(whoami)

7. versfy docker: docker ps

run a nginx server using docker
8. run docker: docker run -p 80:80 nginx

verify nginx server is running
9. check running: curl localhost:8081

Build own docker to customize
10. create Dockerfile:
FROM nginx:stable
# support running as arbitrary user which belogs to the root group
RUN chmod g+rwx /var/cache/nginx /var/run /var/log/nginx
# change welcome page 
RUN sed -i.bak -e 's/Welcome/Welcome HONGQI/' /usr/share/nginx/html/index.html
#COPY index.html /usr/share/nginx/html/index.html
# change wellknown port 80 to 8081
RUN sed -i.bak -e 's/listen\( *\)80;/listen 8081;/' -e 's/listen\(.*\)80;//' /etc/nginx/conf.d/default.conf
EXPOSE 8081
# comment user directive as master process is run as user in OpenShift anyhow
RUN sed -i.bak 's/^user/#user/' /etc/nginx/nginx.conf

11. build new image 
 image=wavecloud/nginx-std
 port=8081
 app=nginx

 echo "create and push docker images"
 docker login -uzhanghongqi -pa568Pqt123
 docker build -f Dockerfile -t $image  .
 docker push $image

12. docker run --name $app -p $port:$port $image
13. verify:
    http://localhost:$port

10.end
```
### Kubernetes(kind) etc
kubernetes(kind) is docker manager,
Using kubernetes(kind), application can be scale up/down pods more easy than using docker run
```
0. sign up account at 
   https://hub.docker.com/

1. docker install ( centos or ubuntu ignore if installed)
   curl -fsSL https://get.docker.com/ | sh
   (curl -fsSL https://download.docker.com/liunx/ubuntu/grg | sudo apt-key add - && \
   sudo add-apt-repository "deb [arch=amd64] https:///download.docker.com/linux/ubuntu $(ls_release -cs) stable" && \
   sudo apt-get install docker-ce -y)

2. kubectl install
   curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" &&\
   sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

3. kind install
    curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.17.0/kind-linux-amd64
    chmod +x ./kind
    sudo mv ./kind /usr/local/bin/kind
    (install using: go install sigs.k8s.io/kind@v0.17.0)

4. Create cluster
   Kind create cluster

5. Verify cluster
   kind get cluster&& kc cluster-info --context kind-kind

6. Create docker image and run application
  image=wavecloud/nginx-std
  port=8081
  app=nginx
  echo "create and push docker images"
  docker login -uzhanghongqi -ppassword
  docker build -f Dockerfile -t $image  .
  docker push $image

  echo "run docker images"
  kubectl create deployment $app --image=$image --port=$port
  kubectl expose deployment $app --target-port=$port --type=NodePort

7. expose port
  kubectl port-forward svc/nginx  8888:$port &

8. verify
  curl http://localhost:8888
```
### Yaml Etc
Using Yaml to represent Kubernetes Data model
```
1 install plugin krew
   Wget https://github.com/kubernetes-sigs/krew/releases/download/v0.4.3/krew-linux_amd64.tar.gz
   Tar -xvf krew-linux_amd64.tar.gz
  ./krew-linux_amd64 install krew
   Export PATH=$HOME/.brew/bin:$PATH
  
2. install kubectl neat
   kubectl krew install neat

3. export deploy/svc yaml
   kubectl get svc nginx |kc neat > service.yaml
   kubectl get deploy nginx|kc neat > deploy.yaml

```
### Jenkins Etc
Using Jenkins, automation pipeline can be run easily and conveniently.
```
1. install jenkins:
   https://www.jenkins.io/download/thank-you-downloading-windows-installer-stable
  ( for centos: 
   sudo yum install java-1.8.0-openjdk-devel
   curl --silent --location http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo | sudo tee /etc/yum.repos.d/jenkins.repo
   sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
   sudo yum install jenkins;
   sudo systemctl start jenkins
   sudo systemctl enable jenkins )

2. create a slave on centos with IP address & pass (if jenkins install on window)

3. create a Jenkinsfile file and agent name centos7 on repo
   properties([
    pipelineTriggers([githubPush()]),
    parameters([
            choice(name: 'choice1', choices: ['dev','qa','prod'], description: 'input cluster'),
             string(name: 'StringSet', defaultValue: 'Mr Jenkins', description: 'Who should I say hello to?'),
          ])
    ])
   pipeline {
    agent any
    options { timestamps () }
    tools { oc params.ocversion }
    environment { globalvar='global variable'}
    stages {
        stage('Stage: Initial and Clean'){
            steps { 
                script {
                       //TO DO
                       }
                  }
              }
}
}

4. create a jenkins job pipeline and put repo url with pass
   entry file: Jenkinsfile

5. create credentialID for repo id and pass 

6. start run jenkins job and pipeline is running on centos7

8.end

```











```

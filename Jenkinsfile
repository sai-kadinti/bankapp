pipeline {
    agent { label "dev" }
    tools 
    {
        maven 'maven3'
    }
    environment
    {
        DEV_SERVER_IP = '3.83.66.78'
        GIT_REPO_URL = 'https://github.com/sai-kadinti/bankapp.git'
        GIT_REPO_BRANCH = 'master'
        SONAR_IP = 'http://3.83.66.78:9000/'
        SONAR_TOKEN = 'squ_155da741bffc31d1fcbee08bb74e6fdedf9d53e3'
        QA_SERVER_IP = '13.222.235.18'
        CONTEXT_PATH = 'test'
        QA_SERVER_URL = 'http://13.222.235.18:8888/'
        DOCKER_USER_NAME= "kadintisai"
        HOST_PORT = '8888'
    }
    options
    {
        timestamps()
    }

    stages 
    {
        stage('Download the code') 
        {
            steps 
            {
                git branch: "${GIT_REPO_BRANCH}" , url: "${GIT_REPO_URL}"
                sh 'echo "PWD: $(pwd)" && ls -lrth'
            }
        }
        stage('Scan the code') 
        {
            steps 
            {
                sh ''' mvn sonar:sonar \\
                        -Dsonar.host.url=${SONAR_IP} \\
                        -Dsonar.login=${SONAR_TOKEN}'''
            }
        }
        stage('Test the code') 
        {
            steps 
            {
                sh '''
                echo "testing the code"
                mvn clean test
                '''
            }
        }
        stage('Build the code') 
        {
            steps 
            {
                sh '''
                echo "Building the code"
                mvn clean package
                '''
            }
        }
        stage('Deploy the code to QA') 
        {
            steps 
            {
                script
                {
                    sh '''
                    ssh -o StrictHostKeyChecking=no root@${QA_SERVER_IP} 'mkdir -p /root/bank_app/'
                    scp \$WORKSPACE/target/banking-app-0.0.1-SNAPSHOT.jar root@${QA_SERVER_IP}:/root/bank_app/
                    ssh -o StrictHostKeyChecking=no root@${QA_SERVER_IP} 'nohup java -jar /root/bank_app/banking-app-0.0.1-SNAPSHOT.jar > app.log 2>&1 &'
                    '''
                }
            }
        }
        stage ('Build the docker image')
        {
            steps
            {
                sh 'docker build -t ${DOCKER_USER_NAME}/${JOB_NAME}:${BUILD_NUMBER} .'
            }
        }
        stage ("docker login")
        {
            steps
            {
                withCredentials([string(credentialsId: 'docker_pwd', variable: 'docker_pwd')])
                {
                    sh "docker login -u ${DOCKER_USER_NAME} -p ${docker_pwd}"
                    echo "Docker login success"
                }

            }
        }
        stage ("Push the image to DockerHub")
        {
            steps
            {
                sh "docker push ${DOCKER_USER_NAME}/${JOB_NAME}:${BUILD_NUMBER}"
                echo "Image pushed to DockerHub"
            }
        }
        stage ("Run the Container")
        {
            steps
            {
                sh "docker run --name bankapp_${BUILD_NUMBER} -p ${HOST_PORT}:8085 -d ${DOCKER_USER_NAME}/${JOB_NAME}:${BUILD_NUMBER}"
            }
        }
    }
    post
    {
        always
        {
            echo "Pipeline succed......!"
            echo "QA access link: http://${QA_SERVER_IP}:8085"
            echo "Prod access link: http://${DEV_SERVER_IP}:${HOST_PORT}"
        }
        failure
        {
            echo "Pipeline failed..........!!"
        }
    }
}

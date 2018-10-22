node {
    def app
    def gk_owner = "gkirok"
    def gk_customer = "tikal"
    def gk_image = "gkirok/ipinfo"
    def versionNumber = 1.0
    def TERRAFORM_CMD = 'docker run --network host -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} -w /app -v ${HOME}/.ssh:/root/.ssh -v $(pwd)/../terraform-result/${BRANCH_NAME}:/app hashicorp/terraform:light'

    stage ('prepare: determine version') {
        version = "${versionNumber}.${env.BUILD_NUMBER}-${env.BRANCH_NAME}"
    }
    stage('prepare: clone repo') {
        checkout scm
        sh "if [ ! -d \"../terraform-result/${env.BRANCH_NAME}\" ]; then mkdir -p ../terraform-result/${env.BRANCH_NAME}; fi; cp -rf terraform/* ../terraform-result/${env.BRANCH_NAME}/"
    }

    stage('docker: build test image') {
        /* This builds the actual image; synonymous to
         * docker build on the command line */

        app = docker.build("${gk_image}:test-${version}", "--build-arg RELEASE_TESTING=1 .")
    }
    stage('docker: build & push image') {
        /* This builds the actual image; synonymous to
         * docker build on the command line */
        docker.withRegistry('', '687f214f-6fa4-4f03-a90d-666880ed733f') {
            app = docker.build("${gk_image}:${version}")
            app.push()

            if (env.BRANCH_NAME == 'master') {
                app.push('latest')
            }
        }
    }
    stage('terraform: pull & init') {
        docker.image("hashicorp/terraform:light")
        sh "${TERRAFORM_CMD} init -backend=true -input=false"
    }
    stage('terraform: plan') {
        withCredentials([string(credentialsId: '1e72433f-2b8b-44b0-a339-57ae2a884ea4', variable: 'AWS_ACCESS_KEY_ID'), string(credentialsId: 'd2fc2528-658d-4995-a8ba-c9e4f2d09e2d', variable: 'AWS_SECRET_ACCESS_KEY'), string(credentialsId: '4bdb8cb3-18f8-4e08-bf2c-73c006c12d15', variable: 'JENKINS_IP'), string(credentialsId: '6f78163f-c0f7-4b96-af9c-92a836e34171', variable: 'ACCESS_IP')]) {
            sh "${TERRAFORM_CMD} plan -out=tfplan -input=false -var gk_access_ip=${ACCESS_IP} -var gk_jenkins_ip=${JENKINS_IP} -var gk_rg_name=${env.BRANCH_NAME} -var gk_customer=${gk_customer} -var gk_owner=${gk_owner}"
        }
        if (env.BRANCH_NAME == 'master') {
            script {
                timeout(time: 10, unit: 'MINUTES') {
                    input(id: "Deploy Gate", message: "Deploy ${env.BRANCH_NAME}?", ok: 'Deploy')
                }
            }
        }
    }
    stage('terraform: apply') {
        withCredentials([string(credentialsId: '1e72433f-2b8b-44b0-a339-57ae2a884ea4', variable: 'AWS_ACCESS_KEY_ID'), string(credentialsId: 'd2fc2528-658d-4995-a8ba-c9e4f2d09e2d', variable: 'AWS_SECRET_ACCESS_KEY'), string(credentialsId: '4bdb8cb3-18f8-4e08-bf2c-73c006c12d15', variable: 'JENKINS_IP'), string(credentialsId: '6f78163f-c0f7-4b96-af9c-92a836e34171', variable: 'ACCESS_IP')]) {
            sh "${TERRAFORM_CMD} apply -lock=false -input=false tfplan"
            sh "echo '[ipinfo]' > ansible_playbooks/inventory.ini;"
            sh "${TERRAFORM_CMD} output -json gk_server_public_ips | jq '.value' | head -n -1 | tail -n +2 | sed 's/[,\"]//g' >> ansible_playbooks/inventory.ini"
            sh "${TERRAFORM_CMD} output -json gk_server_private_ips | jq '.value' | head -n -1 | tail -n +2 | sed 's/[,\"]//g' >> ansible_playbooks/hosts"
            server_ip=readFile('ansible_playbooks/inventory.ini').trim()
        }
    }

    stage('ansible: requirements') {
        ansiblePlaybook(
            playbook: 'ansible_playbooks/main.yml',
            inventory: 'ansible_playbooks/inventory.ini',
            credentialsId: '3276ccf3-13bc-4408-b815-7b07bfd4e972',
            becomeUser: 'centos',
            sudo: true)
    }
    stage('ansible: deploy') {
        withCredentials([string(credentialsId: 'cd9e3953-72b4-400e-9926-ab48a786179d', variable: 'ipinfo_token')]) {
            ansiblePlaybook(
                playbook: 'ansible_playbooks/deploy.yml',
                inventory: 'ansible_playbooks/inventory.ini',
                credentialsId: '3276ccf3-13bc-4408-b815-7b07bfd4e972',
                becomeUser: 'centos',
                sudo: true,
                extras: "-e ipinfo_version=\"${version}\" -e ipinfo_token=\"${ipinfo_token}\" -e ipinfo_image=\"${gk_image}\"")
        }
    }
    stage('result') {
        echo "IPinfo version ${version} deployed to ${server_ip}"
    }
}

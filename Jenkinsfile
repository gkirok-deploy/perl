node {
    def app
    def versionNumber = 1.0
    def TERRAFORM_CMD = 'docker run --network host -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} -w /app -v ${HOME}/.ssh:/root/.ssh -v $(pwd)/terraform:/app hashicorp/terraform:light'

    stage('Clone repository') {
        /* Let's make sure we have the repository cloned to our workspace */

        checkout scm
    }
    stage ('Determine version') {
        branchVersion = env.BRANCH_NAME
        branchVersion = branchVersion.replaceAll(/origin\//, "") 
        branchVersion = branchVersion.replaceAll(/\W/, "-")
        version = "${versionNumber}.${env.BUILD_NUMBER}-${branchVersion}"
    }
    stage('Build test image') {
        /* This builds the actual image; synonymous to
         * docker build on the command line */

        app = docker.build("gkirok/ipinfo:test-${version}", "--build-arg RELEASE_TESTING=1 .")
    }
    stage('Build & push image') {
        /* This builds the actual image; synonymous to
         * docker build on the command line */
        docker.withRegistry('', '687f214f-6fa4-4f03-a90d-666880ed733f') {
            app = docker.build("gkirok/ipinfo:${version}")
            app.push()

            if (env.BRANCH_NAME == 'master') {
                app.push('latest')
            }
        }
    }
    stage('terraform: pull & init') {
        docker.image("hashicorp/terraform:light")
        withCredentials([string(credentialsId: '1e72433f-2b8b-44b0-a339-57ae2a884ea4', variable: 'AWS_ACCESS_KEY_ID'), string(credentialsId: 'd2fc2528-658d-4995-a8ba-c9e4f2d09e2d', variable: 'AWS_SECRET_ACCESS_KEY')]) {
            sh "${TERRAFORM_CMD} init -backend=true -input=false"
        }
    }
    stage('terraform: plan') {
        withCredentials([string(credentialsId: '1e72433f-2b8b-44b0-a339-57ae2a884ea4', variable: 'AWS_ACCESS_KEY_ID'), string(credentialsId: 'd2fc2528-658d-4995-a8ba-c9e4f2d09e2d', variable: 'AWS_SECRET_ACCESS_KEY')]) {
            sh "${TERRAFORM_CMD} plan -out=tfplan -input=false"
        }
        script {
            timeout(time: 10, unit: 'MINUTES') {
                input(id: "Deploy Gate", message: "Deploy ${params.project_name}?", ok: 'Deploy')
            }
        }
    }
    stage('terraform: apply') {
        withCredentials([string(credentialsId: '1e72433f-2b8b-44b0-a339-57ae2a884ea4', variable: 'AWS_ACCESS_KEY_ID'), string(credentialsId: 'd2fc2528-658d-4995-a8ba-c9e4f2d09e2d', variable: 'AWS_SECRET_ACCESS_KEY')]) {
            sh "${TERRAFORM_CMD} apply -lock=false -input=false tfplan"
        }
    }
}
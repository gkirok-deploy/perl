node {
    def app
    def versionNumber = 1.0
    def TERRAFORM_CMD = 'docker run --network host -w /app -v ${HOME}/.aws:/root/.aws -v ${HOME}/.ssh:/root/.ssh -v $(pwd):/app hashicorp/terraform:light'

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
        sh "${TERRAFORM_CMD} init -backend=true -input=false"
    }
    stage('terraform: plan') {
        sh "${TERRAFORM_CMD} plan -out=tfplan -input=false"
        script {
            timeout(time: 10, unit: 'MINUTES') {
                input(id: "Deploy Gate", message: "Deploy ${params.project_name}?", ok: 'Deploy')
            }
        }
    }
    stage('terraform: apply') {
        sh "${TERRAFORM_CMD} apply -lock=false -input=false tfplan"
    }
}

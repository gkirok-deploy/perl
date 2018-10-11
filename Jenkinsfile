node {
    def app
    def versionNumber = 1.0

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
}

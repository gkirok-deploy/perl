node {
    def app

    stage('Clone repository') {
        /* Let's make sure we have the repository cloned to our workspace */

        checkout scm
    }
    stage ('Determine Branch Version') {
        branchVersion = env.BRANCH_NAME
        branchVersion = branchVersion.replaceAll(/origin\//, "") 
        branchVersion = branchVersion.replaceAll(/\W/, "-")
        version = "${env.BUILD_NUMBER}-${branchVersion}"
    }
    stage('Build test image') {
        /* This builds the actual image; synonymous to
         * docker build on the command line */

        app = docker.build("gkirok/geo-ipinfo:test-${version}", "--build-arg RELEASE_TESTING=1 .")
    }
}

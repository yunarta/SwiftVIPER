properties([buildDiscarder(logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '', numToKeepStr: '5'))])

node("cocoa") {
    try {
        stage("Checkout") {
            def git = checkout scm
            branch = git["GIT_BRANCH"]
            sh "mkdir static-analysis"
        }

        stage("Quality Check") {
            sh """printenv
            swiftlint autocorrect --config swiftlint.yml
            if [[ \$(git diff --stat) != '' ]]; then
                git branch ${branch} -t origin/${branch}
                git checkout ${branch}
                git add -u
                git commit -m "CI: Auto correction"
                git push origin
            fi
            """

            try {
                sh """sed -ie 's/xcode/checkstyle/' swiftlint.yml
                swiftlint lint --config swiftlint.yml > static-analysis/swiftlint.xml"""
            } catch (error) {
                currentBuild.result = 'UNSTABLE'
            }
        }

        stage("Publish") {
            checkstyle canComputeNew: false, defaultEncoding: "", healthy: "", pattern: "static-analysis/swiftlint.xml", unHealthy: ""
        }
    } finally {
        cleanWs()
    }
}

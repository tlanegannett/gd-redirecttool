
node {
   dest = ''
   env.COOKBOOK_REPO = 'GannettDigital/chef-test-redirecttoolserver'
   env.COOKBOOK_NAME = 'test-redirecttoolserver'
   // IF you need to set additional environment vars for your build job
   // AND they are OK being in a github repo put them here
   // e.g. env.LINUX_INSTANCE_SIZE = 't2.small'
   try {
   stage 'Github checkout'
     checkout scm
     v = version()
     sh "echo -n `git rev-parse HEAD` > .git/commit-id"
     env.BRANCH_COMMIT = readFile('.git/commit-id')
     echo "Testing ${env.COOKBOOK_NAME} ${v}\nBRANCH: ${env.BRANCH_NAME}\nCOMMIT: ${env.BRANCH_COMMIT}"
   if (env.BRANCH_NAME != 'master') {
     dest = 'test'
     stage 'check PR script'
     // run our basic pr version check tests
       sh 'bash ${JENKINS_HOME}/dev-ops/ci/check_pr_versions.sh'
   } else {
     dest = 'chef-server'
   }
   stage 'GD foodcritic'
     // Run our foodcritic tests
     sh 'chef exec foodcritic -f "any" -X "spec/**/*" -X "test/**/*" -I $FC_RULES_LOCATION .'
   stage 'EC2 integration tests'
     // this is the "chef exec bundle exec rake ec2 job"
     build job: 'rake_ec2_sub', parameters: [string(name: 'COOKBOOK_BRANCH', value: "${env.BRANCH_COMMIT}"),
                                             string(name: 'COOKBOOK_REPO', value: "${env.COOKBOOK_REPO}")]
   if (env.BRANCH_NAME == 'master') {
     stage 'supermarket upload'
       build job: 'supermarket_upload_sub', parameters: [string(name: 'COOKBOOK_BRANCH', value: "${env.BRANCH_COMMIT}"),
                                                         string(name: 'COOKBOOK_REPO', value: "${env.COOKBOOK_REPO}"),
                                                         string(name: 'COOKBOOK_NAME', value: "${env.COOKBOOK_NAME}")]
     try {
       stage 'chef server upload'
         build job: 'chef_upload_sub', parameters: [string(name: 'COOKBOOK_BRANCH', value: "${env.BRANCH_COMMIT}"),
                                                    string(name: 'COOKBOOK_REPO', value: "${env.COOKBOOK_REPO}"),
                                                    string(name: 'COOKBOOK_NAME', value: "${env.COOKBOOK_NAME}")]
         currentBuild.result = "SUCCESS"
     }
     catch (err) {
       stage 'supermarket rollback'
         build job: 'supermarket_rollback_sub', parameters: [string(name: 'COOKBOOK_BRANCH', value: "${env.BRANCH_COMMIT}"),
                                                             string(name: 'COOKBOOK_REPO', value: "${env.COOKBOOK_REPO}"),
                                                             string(name: 'COOKBOOK_NAME', value: "${env.COOKBOOK_NAME}")]
         currentBuild.result = "FAILURE"
     }
   }
   stage 'notify or tag'
     // we could notify slack directly with a plugin
     echo 'call pipeline-alerting'
     if (env.BRANCH_NAME != 'master') {
       // if you got here and you're not master then you're golden
       currentBuild.result = "SUCCESS"
     }
     build job: 'pipeline-alerting', parameters: [string(name: 'TRIGGERING_JOB_NAME', value: "${env.COOKBOOK_NAME}"),
                                                 string(name: 'TRIGGERING_BUILD_NUMBER', value: "${env.BUILD_NUMBER}"),
                                                 string(name: 'TRIGGERING_ENVIRONMENT', value: 'tools'),
                                                 string(name: 'TRIGGERING_BUILD_URL', value: "${env.BUILD_URL}"),
                                                 string(name: 'TRIGGERING_GIT_URL', value: "https://github.com/${env.COOKBOOK_REPO}/"),
                                                 string(name: 'TRIGGERING_GIT_COMMIT', value: "${env.BRANCH_COMMIT}"),
                                                 string(name: 'APP_NAME', value: "${env.COOKBOOK_NAME}"),
                                                 string(name: 'EVENT_TYPE', value: 'deploy'),
                                                 string(name: 'TEST_TYPE', value: 'none'),
                                                 string(name: 'PUBLISH_DESTINATION', value: "${dest}"),
                                                 string(name: 'TEAM', value: 'paas-delivery'),
                                                 string(name: 'BUILD_STATUS', value: "${currentBuild.result}")]
  }
  catch (err) {
    // if anything broke early on before the master logic
    currentBuild.result = "FAILURE"
    stage 'notify or tag'
      build job: 'pipeline-alerting', parameters: [string(name: 'TRIGGERING_JOB_NAME', value: "${env.COOKBOOK_NAME}"),
                                                  string(name: 'TRIGGERING_BUILD_NUMBER', value: "${env.BUILD_NUMBER}"),
                                                  string(name: 'TRIGGERING_ENVIRONMENT', value: 'tools'),
                                                  string(name: 'TRIGGERING_BUILD_URL', value: "${env.BUILD_URL}"),
                                                  string(name: 'TRIGGERING_GIT_URL', value: "https://github.com/${env.COOKBOOK_REPO}/"),
                                                  string(name: 'TRIGGERING_GIT_COMMIT', value: "${env.BRANCH_COMMIT}"),
                                                  string(name: 'APP_NAME', value: "${env.COOKBOOK_NAME}"),
                                                  string(name: 'EVENT_TYPE', value: 'deploy'),
                                                  string(name: 'TEST_TYPE', value: 'none'),
                                                  string(name: 'PUBLISH_DESTINATION', value: "${dest}"),
                                                  string(name: 'TEAM', value: 'paas-delivery'),
                                                  string(name: 'BUILD_STATUS', value: "${currentBuild.result}")]
  }
}
def version() {
  def matcher = readFile('metadata.rb') =~ /version\s+['"](\d+\.\d+\.\d+)['"]/
  matcher ? matcher[0][1] : null
}

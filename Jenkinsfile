pipeline {
  agent any  
  environment {
    doError = '0'
    VERSION = '0.1'
    APPLICATION_NAME = 'dev-hmz-redapp'
    DEPLOYMENT_CONFIG_NAME = 'CodeDeployDefault.OneAtATime'
    DEPLOY_BUCKET='hmz-redapp-frontend'
    GROUP_NAME='dev-hmz-redapp'
  }   
  stages {
    stage ('Clone repo') {
      steps {
        bat '''
        if exist redapp rmdir redapp /q /s
        git clone git@github.com:hmanzer/redapp.git
        cd redapp
        '''    
      }
    }  
    stage ('Deploy') {
      steps {
        bat '''
        set ZIP_FILE=redapp.%VERSION%.zip
        zip -r %ZIP_FILE% app/appsec.yml app/codedeploy app/index.js app/package.json app/home.html
        aws s3 cp $ZIP_FILE s3://%DEPLOY_BUCKET%
        aws deploy create-deployment --application-name %APPLICATION_NAME% --deployment-config-name %DEPLOYMENT_CONFIG_NAME% --deployment-group-name %GROUP_NAME% --s3-location bucket=%DEPLOY_BUCKET%,bundleType=zip,key=%ZIP_FILE% | jq --raw-output '.deploymentId' > temp.txt
        set /p D_ID=<temp.txt
        aws deploy wait deployment-successful --deployment-id %D_ID%
        '''
      }
    }
  }
    // Post-build actions
}
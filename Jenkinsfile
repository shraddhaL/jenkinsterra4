pipeline {
     agent any
	 tools {
        maven 'maven' 
        
    } 
	 environment {
        registryCredential ='docker_hub'
		 registry = "shraddhal/tomcat_develop"
		// UUID uuid = UUID.randomUUID()
		  uuidver = UUID.randomUUID().toString()
    }
    stages{ 
	     stage('terraform apply aws_tomcat') {
	      steps {
		       sh 'terraform init'
		      sh 'terraform plan'
		         sh 'sudo chmod 777 /opt/tomcat/tomcat9/webapps'
		  sh 'sudo chmod 777 /opt/tomcat/tomcat9/webapps/roshambo.war'
                    sh 'terraform apply  -auto-approve=true  -target=module.aws_tomcat'
	      }
        }
	    
	     stage('UUID Monitor') {
             steps {
                 
                    sh '''url='http://devopsteamgoa.westindia.cloudapp.azure.com:8081/roshambo/game.html'
		     
		    code=`curl -sL --connect-timeout 20 --max-time 30 -w "%{http_code}\\\\n" "$url" -o /dev/null`'''
		     
		       script{
				def var = sh(script: 'curl http://devopsteamgoa.westindia.cloudapp.azure.com:8081/roshambo/version.html', returnStdout: true)
			 if(env.uuidver == var)
			      echo 'Latest version'
			 else
			      echo 'Older version'
			       
			        
		      }
	     } 
         }
    }
	
post{
		always{
			  
		         sh 'terraform destroy --auto-approve'
		}
	}
	
}

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
		       sh 'sudo chmod 777 /opt/tomcat/tomcat9/webapps'
		       sh 'sudo chmod 777 /opt/tomcat/tomcat9/webapps/roshambo.war'
		      
		      
		      
		withCredentials([string(credentialsId: 'access', variable: 'access'), string(credentialsId: 'secret', variable: 'secret'),file(credentialsId: 'private_key', variable: 'private_key')]){
				sh 'terraform init'
				sh 'terraform apply -target=module.aws_tomcat -var 'access=$access' -var 'secret=$secret' -var 'private_key=$private_key'  -auto-approve'
		}
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

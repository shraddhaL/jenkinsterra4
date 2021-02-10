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
	    
	    stage('Deploy on azure vm') {
			     steps {
		            deploy adapters: [tomcat9(credentialsId: 'tomcat', path: '', url: 'http://devopsteamgoa.westindia.cloudapp.azure.com:8081/')], contextPath: 'roshambo', onFailure: false, war: '**/*.war'
		             }
         		}
	    stage('terraform apply aws_tomcat') {
	      steps {
		       sh 'sudo chmod 777 /opt/tomcat/tomcat9/webapps'
		       sh 'sudo chmod 777 /opt/tomcat/tomcat9/webapps/roshambo.war'
		      
		      
		      
		withCredentials([string(credentialsId: 'access', variable: 'access'), string(credentialsId: 'secret', variable: 'secret'),file(credentialsId: 'private_key', variable: 'private_key'),file(credentialsId: 'public_key', variable: 'public_key')]){
				
			//sh 'terraform apply -var "access=$access" -var "secret=$secret" -var "private_key=$private_key" -auto-approve'  -target module.aws_tomcat
		sh '''cd aws_tomcat
		terraform init
		terraform apply -var "access=$access" -var "secret=$secret" -var "private_key=$private_key" -var "public_key=$public_key" -auto-approve'''
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
			 withCredentials([string(credentialsId: 'access', variable: 'access'), string(credentialsId: 'secret', variable: 'secret'),file(credentialsId: 'private_key', variable: 'private_key'),file(credentialsId: 'public_key', variable: 'public_key')]){
			 sh '''cd aws_tomcat
		             terraform destroy  -var "access=$access" -var "secret=$secret" -var "private_key=$private_key" -var "public_key=$public_key"  --auto-approve
			  '''
			sh 'terraform destroy --auto-approve'
			 }
		}
	}
	
}

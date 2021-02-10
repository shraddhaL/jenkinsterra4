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
	    stage('Clone repository') {
			 steps {	       
				git 'https://github.com/shraddhaL/jenkinsterra4.git'
			   }
		 }
	    
	     stage('UUID gen') {
	    
		steps {
			//  sh 'echo $uuidver> src/main/webapp/version.html'
			
                writeFile file: "src/main/webapp/version.html", text: uuidver
        }
        }
	    
	 stage('Build Jar') {
	    
		steps {
		        sh 'mvn clean package'
        }
        }
	  stage('Build Image') {
            steps {
                script {
                	app = docker.build(registry)
                }
            }
        }
	       stage('Docker Push') {
            steps {
		    script{
			    docker.withRegistry('https://registry.hub.docker.com', registryCredential ) {
			  app.push("${BUILD_NUMBER}")
			    app.push("latest")
			    }
          }
        }
      }
	
	    

		   /*   stage('Docker Tomcat server') {
			      steps {
					sh 'docker run -d --name mytomcat -p 9090:8080 shraddhal/tomcat_develop:latest'
			    }
			}
			   */
	    
	   
	    stage('terraform init') {
	      steps {
                    sh 'terraform init'
	      }
        }
	   
	      stage('terraform plan') {
	      steps {
                    sh 'terraform plan' -target=module.tomcat_container
	      }
        }
	 
	      stage('terraform apply tomcat_container') {
	      steps {
                    sh 'terraform apply  -auto-approve=true  -target=module.tomcat_container'
	      }
        }
	 
	    
	    
	     stage('UUID develop check') {
              steps {
               		
			sh 'sleep 20'
		      
		       script{
			def var = sh(script: 'curl http://devopsteamgoa.westindia.cloudapp.azure.com:9090/roshambo/version.html', returnStdout: true)
		 if(env.uuidver == var)
		      echo 'Latest version'
		 else
		      echo 'Older version'
			       
			        
		      }
		    }
		}
	 stage('terraform plan selenium ') {
	      steps {
                    sh 'terraform plan' -target=module.selenium_containers
	      }
	    stage('terraform apply selenium_containers_up') {
	      steps {
                    sh 'terraform apply  -auto-approve=true  -target=module.selenium_containers.null_resource.containers_up'
	      }
        }  
	   
	 /*    stage('compose') {
            steps { 
		    dir('end_to_end') {
			 script {
			sh 'docker-compose up -d --scale chrome=3'
			
                 }
		}
	    }
        }*/
	

	 stage('end to end testing') {
            steps {
		    dir('end_to_end') { script {
			  sh 'mvn clean -Dtest="UUIDTest.java" test  -Duuid="$uuidver"'
		    }}
	    }
	 }
	     
	    stage('terraform apply selenium_containers_down') {
	      steps {
                    sh 'terraform apply  -auto-approve=true  -target=module.selenium_containers.null_resource.containers_down'
	      }
        }  
	    
	 /*  stage('docker clean') {
					    steps { 
						    dir('end_to_end') {
							 script {
							sh 'docker-compose down'
							//sh 'docker rm -f mytomcat'
						 }
						}   
				    }
		 		}
		*/
	  
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
			  sh '''cd aws_tomcat
		             terraform destroy --auto-approve
			  '''
		        // sh 'terraform destroy --auto-approve'
		}
	}
	
}

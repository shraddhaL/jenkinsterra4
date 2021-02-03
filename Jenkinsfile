pipeline {
     agent any
	 tools {
        maven 'maven' 
        
    } 
	 environment {
        registryCredential ='docker_hub'
		 registry = "shraddhal/tomcat_develop"
		 UUID uuid = UUID.randomUUID()
    }
    stages { 	
 stage('Clone repository') {
			   steps {	       
				git 'https://github.com/shraddhaL/jenkinsterra4.git'
			   }
			   }
	    
	     stage('UUID gen') {
	    
		steps {
			  sh 'echo $uuid> src/main/webapp/version.html'
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
			    docker.withRegistry( 'https://registry.hub.docker.com', registryCredential ) {
			    app.push("${BUILD_NUMBER}")
			    app.push("latest")
			    }
          }
        }
      }
      
      stage('Docker Tomcat server') {
              steps {
               		
			sh 'docker run -d --name mytomcat -p 9090:8080 shraddhal/tomcat_develop:latest'
		      
            }
        }
	    
	     stage('UUID develop check') {
              steps {
               		
			sh 'sleep 10'
		      
		       script{
			def var = sh(script: 'curl http://devopsteamgoa.westindia.cloudapp.azure.com:9090/roshambo/version.html', returnStdout: true)
			  def uuid_generated= env.uuid 
			       echo var
			       echo uuid_generated
			       sh 'curl http://devopsteamgoa.westindia.cloudapp.azure.com:9090/roshambo/version.html'
			       
			        var.getClass()
			        uuid_generated.getClass()
			       
			       
		 if(uuid_generated.equals(var))
		      echo 'Latest version'
		 else
		      echo 'Older version'
		      }
		     /* 
		      var=$(curl --silent -L "http://devopsteamgoa.westindia.cloudapp.azure.com:9090/MusicStore/version.html" |grep $uuid |wc -l)
			if [ $var -eq 1 ]
			then
			    echo "Latest Version"
			else
			    echo "Old Version"
			fi */

		      
		      
		      
            }
        }
	/*    
	    
  stage('compose') {
            steps { 
		    dir('end_to_end') {
			 script {
			sh 'docker-compose up -d --scale chrome=3'
			
                 }
		}
	    }
        }
	

	 stage('end to end testing') {
            steps {
		    dir('end_to_end') { script {
			  sh 'mvn clean -Dtest="UUIDTest.java" test  -Duuid="$uuid"'
		    }}
	    }
	 }
	 
	   stage('docker clean') {
					    steps { 
						    dir('end_to_end') {
							 script {
							sh 'docker-compose down'
							sh 'docker rm -f mytomcat'
						 }
						}   
				    }
				}

	  
	    stage('Deploy on azure vm') {
			     steps {
		           //  deploy adapters: [tomcat9(credentialsId: 'tomcat', path: '', url: 'http://devopsteamgoa.westindia.cloudapp.azure.com:8081/')], contextPath: 'roshambo', onFailure: false, war: '.war'
		             }
         		}
   stage('UUID Monitor') {
             steps {
                 
                    sh '''url='http://devopsteamgoa.westindia.cloudapp.azure.com:8081/roshambo/game.html'
		    
code=`curl -sL --connect-timeout 20 --max-time 30 -w "%{http_code}\\\\n" "$url" -o /dev/null`'''
		     
		     script{
			def uuid_res = sh(script: 'curl http://devopsteamgoa.westindia.cloudapp.azure.com:8081/roshambo/version.html', returnStdout: true)
		 if(env.uuid == uuid_res)
		      echo 'Latest version'
		 else
		      echo 'Older version'
		      }
               
             }
         } 
	 
	 * * / *
		 
		 
*/
    }
}

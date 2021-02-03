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
			  sh '''
				echo $uuid> src/main/webapp/version.html
				cat src/main/webapp/version.html
				echo UUID=$uuid> propsfile'''
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
               		
			sh '''sleep 15
			echo $uuid
			var=$(curl --silent -L "http://devopsteamgoa.westindia.cloudapp.azure.com:9090/roshambo/version.html" |grep $uuid |wc -l)
			if [ $var -eq 1 ]
			then
			    echo "Latest Version"
			else
			    echo "Old Version"
			fi '''
		      
            }
        }
	    
	 
	 /*stage('archive') {
              steps {
               		archiveArtifacts  'target/*.war'
            }
        } */
        
	  
       /*   dir(''){
            sh "pwd"
          }*/
         
  stage('compose') {
            steps { 
		    dir('end_to_end') {
			 script {
			sh 'docker-compose up -d --scale chrome=3'
			
                 }
		}
	    }
        }
	/*    stage('archive Artifacts') {
            steps {
                script {
			archiveArtifacts artifacts: 'docker-compose.yml', followSymlinks: false
			}
	    }
        }  */

	 stage('end to end testing') {
            steps {
		    dir('end_to_end') { script {
			    //bat 'docker system prune --all --volumes --force'
		   // sh 'cat propsfile'
			//--> //sh 'mvn -Dtest="SearchTest.java,SearchTest2.java" test'
			    sh 'echo $uuid'
			  sh 'mvn clean -Dtest="UUIDTest.java" test  -Duuid="$uuid"'
		    }}
	    }
	 }
	 
	     stage('compose-down') {
            steps { 
		    dir('end_to_end') {
			 script {
			sh 'docker-compose down'
                 }
		}   
	    }
        }

	  
	    stage('Deploy on azure vm') {
             steps {
		   
             deploy adapters: [tomcat9(credentialsId: 'tomcat', path: '', url: 'http://devopsteamgoa.westindia.cloudapp.azure.com:8081/')], contextPath: 'roshambo', onFailure: false, war: 'roshambo/target/*.war'
             }
         }
         
          stage('Monitor') {
             steps {
                 
                    sh '''url='http://devopsteamgoa.westindia.cloudapp.azure.com:8081/roshambo/game.html'
code=`curl -sL --connect-timeout 20 --max-time 30 -w "%{http_code}\\\\n" "$url" -o /dev/null`'''
                 
               
             }
         } 
	    
/*	    
curl -sL --connect-timeout 20 --max-time 30 -w "%{http_code}\\\\n" "$url" -o /dev/null
	*/    
	    
    }
    post{
	     always{
     sh 'docker rm -f mytomcat'
                         }
    }
}

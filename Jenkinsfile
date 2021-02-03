pipeline {
     agent any
	 tools {
        maven 'maven' 
        
    } 
	 environment {
        registryCredential ='docker_hub'
		 registry = "shraddhal/tomcat_develop"
    }
    stages { 	
	    stage('Clone repository') {
			   steps {	       
				git 'https://github.com/shraddhaL/jenkinsterra4.git'
			   }
			   }
	    
	     stage('UUID gen') {
	    
		steps {
			  sh '''name=$(uuidgen)
				touch src/main/webapp/version.html
				echo $name
				echo $name> src/main/webapp/version.html
				echo UUID=$name> propsfile'''
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
                	app = docker.build registry + ":${BUILD_NUMBER}"
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
			var=$(curl --silent -L "http://devopsteamgoa.westindia.cloudapp.azure.com:9090/roshambo/version.html" |grep "$UUID" |wc -l)
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
			//sh 'docker run -d -p 4444:4444 --memory="1.5g" --memory-swap="2g" -v /dev/shm:/dev/shm selenium/standalone-chrome'
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
			  sh '''var=$name
				echo $var
			mvn clean -Dtest="UUIDTest.java" test  -Duuid="$var"'''
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


	   
	    
	  
        }
}

pipeline {
     agent any
	 tools {
        maven 'maven' 
        
    } 
	 environment {
        registryCredential ='docker'
    }
    stages { 	
	    stage('Clone repository') {
			   steps {	       
				git 'https://github.com/shraddhaL/jenkinsdocker-local.git'
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
                	app = docker.build("shraddhal/tomcat_develop")
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
	 
	 stage('archive') {
              steps {
               		archiveArtifacts  'target/*.war'
            }
        } 
        
        
         stage('Docker Cleanup') {
              steps {//  sh 'docker stop mytomcatimage'
			//sh 'docker rm mytomcatimage'
 		        sh 'docker system prune --all --volumes --force'
            }
        }
        
        }
}

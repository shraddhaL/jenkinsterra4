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
    stages { 	
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
                    sh 'terraform plan'
	      }
        }
	 
	      stage('terraform apply') {
	      steps {
                    sh 'terraform apply  -auto-approve=true'
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
		   /*   
		    sh '''var=$(curl --silent -L "http://devopsteamgoa.westindia.cloudapp.azure.com:9090/roshambo/version.html" |grep $uuidver |wc -l)
			if [ $var -eq 1 ]
			then
			    echo "Latest Version"
			else
			    echo "Old Version"
			fi''' 
		      */
		      
		      
            }
        }
	 
	    
 
	 
	 
    }
}

node {
	stage('aspnetcore'){
		def dotnet = docker.image('microsoft/aspnetcore-build')
		dotnet.inside('-u root') {
			sh("dotnet --version")
			sh("bower --version")
			sh("gulp --version")
		}
	}
	stage('nodejs'){
		def nodejs = docker.image('node')
		nodejs.inside {
			sh("node --version")
		}
	}
	stage('golang'){
		def golang = docker.image('golang')
		golang.inside {
			sh("go version")
		}
	}
	stage('ansible'){
		sh("ansible --version")
	}
	stage('docker'){
		sh """
		docker info
		docker images
		"""
	}
}

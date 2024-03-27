# Details 

This dockerfile will install Ruby on Rails, version 2.2.3-x64, in a Windows Server Core based container. It will use the ruby image as a base. In order to run this dockerfile, you must have Ruby installed on your computer. It installs the gems located in the ruby directory. 

All container sample source code is kept under the Virtualization-Documentation git repository in a folder called windows-container-samples.
1. Open a CLI session and change directories to the folder in which you want to store this repository. 
2. Clone the repo to your current working directory:
    git clone https://github.com/MicrosoftDocs/Virtualization-Documentation.git
3. Navigate to the folder in CLI containing the django repository based on where you cloned the Virtualization-Documentation repo.
4. When you are at the directory that the dockerfile resides, run the docker build command to build the container from the Dockerfile.
    docker build -t rails:latest .
5. In command prompt, you will see that all of the gems will be installed successfully.
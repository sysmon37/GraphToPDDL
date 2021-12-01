> This use an old version of optic

## Build Docker image
````
docker build --pull --rm -f "Optic-Docker\DOCKERFILE" -t optic-docker:latest "Optic-Docker"
````


## Execute the container with a host folder
````
docker run -v "Docker_Host_Folder/":/home/optic --rm -ti GraphToPDDL
````
Then you can place your domain and problems files into this folder.


Windows mount docker volume location:
\\wsl$\docker-desktop-data\version-pack-data\community\docker\volumes\

Activate bash on the container:
/bin/bash

>link.txt fix

> :warning: This used an old version of optic.

## Build Docker image
````
docker build --pull --rm -f "Optic-Docker\DOCKERFILE" -t optic-docker:latest "Optic-Docker"
````


## Execute the container with a host folder
Change to your path: <br>*C:\Users\USER\Desktop\GraphToPDDL\Optic-Docker\Docker_Host_Folder*<br>
OR<br>
use $(pwd) <br>
````
docker run -v "PATH":/home/optic --rm -ti optic-docker
````
*Windows:*
````
docker run -v ${pwd}:/home/optic --rm -ti optic-docker 
OR
docker run -v %cd%:/home/optic --rm -ti optic-docker
````
*Linux*
````
docker run -v $(pwd):/home/optic --rm -ti optic-docker 
````
Then you can place your domain and problems files into this folder.

## Run Optic from the container
````
optic domain problem
````

>Windows mount docker volume location:
>\\wsl$\docker-desktop-data\version-pack-data\community\docker\volumes\

>*Activate bash on the container: /bin/bash*

>link.txt fix

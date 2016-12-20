# MarkLogic docker container on windows
This upload speeds up the creation of docker container for MarkLogic on windows. Windows remains as one of the heavily used operating system for hosting MarkLogic server. Please check [Marklogic install guide](https://docs.marklogic.com/guide/installation.pdf) for most current message around operating systems for hosting Marklogic server. We will specify Marklogic as ML in this document.

## Docker environment on windows
This document assumes that user has windows environment on which docker is installed. For better experience with docker on windows,  windows server 2016 is highly recommended as the host OS on which we will create and excute containers. As of October 2016, native container support has been announced on windows server 2016 and that makes the docker experience on windows superior. Windows 10 pro for education or enterprise is another host operating system option for docker on windows. On windows 10 pro, user will have to install and configure [Docker For Windows](https://docs.docker.com/docker-for-windows/).

## Dockerfile to build the docker image
The file for building ML docker image is below. This file is also on [Github](https://github.com/arthi-ramachandran/marklogic/blob/master/Dockerfile).
```
#download the windows server 2016 image from docker
FROM microsoft/windowsservercore

#set the working dir
WORKDIR C:/

#copy MarkLogic msi file
COPY MarkLogic-9.0-20161212-amd64.msi .

#install MarkLogic
Run msiexec.exe /qn /i MarkLogic-9.0-20161212-amd64.msi


#Install cygwin
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';", "$ProgressPreference = 'SilentlyContinue';"]

RUN Invoke-Webrequest https://cygwin.com/setup-x86.exe -OutFile setup.exe -UseBasicParsing
RUN Start-Process -Wait -FilePath setup.exe -ArgumentList '-q', '-D', '-g', '-o', '-A', '-N', '-d', '-L', '-l "c:/cygwin-data"', '-R "c:/cygwin"', '--site "http://mirrors.kernel.org/sourceware/cygwin/"', '-P vim' ; \
    cat .\cygwin\var\log\setup.log.full



EXPOSE 7997 7998 7999 8000 8001 8002 8040 8041 8042
```

Please notice that the MarkLogic installer ( .msi ) file on windows should be in the same directory in which the Dockerfile is kept.

## Creating MarkLogic docker image on windows 
To build the image, you will need to have the .msi file for ML in same directory that has the Dockerfile. Here is the link to get the ML [ Marklogic 8 installer ] (http://developer.marklogic.com/products) for windows.

```
cd .to.path.that.has.Dockerfile.
docker build ml9-windows-nightly .
 where ml9-windows is the name of the docker image that is built
 ```
## Starting  MarkLogic docker container on windows
```
docker run -d -p 8000-8004:8000-8004 --name win-ml9 ml9-windows-nightly POWERSHELL -c "net start MarkLogic;ping -t localhost"

Options:
--name win-ml9    Assign win-ml9 as  the name of your container
-d                Run container in background and assign a container id
ml9-windows-nightly is the name of the docker image that was build in the previoud step

```
Once the container is started in background, we can use the 'docker exec' command to invoke any command we need within the windows container. Example exec command for windows container:
```
docker exec win-ml9 c:\cygwin\bin\bash.exe  -c "net start"
executes the net start command on bash
```


## Licensing

We do not share the docker image with MarkLogic pre installed on public cloud becuase the image has same licensing terms as the MarkLogic .msi windows install file.

The dockerfile uses window server 2016 base image and the following licensing terms apply for use of that docker image.

Microsoft Corporation licenses Windows Server 2016 OS Image as supplement to you (“Supplement”). You are licensed to use the Supplement in conjunction with the underlying host operating system software (“Host Software”) solely to assist running the containers feature in the Host Software. The Host Software license terms apply to your use of the Supplement. 


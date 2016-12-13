# MarkLogic 9 early access docker container on windows
This upload speeds up the creation of docker container for MarkLogic 9 early access on windows. Windows remains as one of the heavily used operating system for hosting MarkLogic server. Please check [Marklogic install guide](https://docs.marklogic.com/guide/installation.pdf) for most current message around operating systems for hosting Marklogic server. We will specify Marklogic 9 early access as ML9 in this document.

## Docker environment on windows
This document assumes that user has windows environment on which docker is installed. For better experience with docker on windows,  windows server 2016 is highly recommended as the host OS on which we will create and excute containers. As of October 2016, native container support has been announced on windows server 2016 and that makes the docker experience on windows superior. Windows 10 pro for education or enterprise is another host operating system option for docker on windows. On windows 10 pro, user will have to install and configure [Docker For Windows](https://docs.docker.com/docker-for-windows/).

## Dockerfile to build the docker image
The file for creating ML9 docker image is :

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

## Creating ML9 container on windows 

## Executing ML9 container on windows

## Licensing



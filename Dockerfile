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

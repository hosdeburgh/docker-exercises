To pull image file from docker hub : **docker pull hosdeburgh2/ubuntu-desktop:latest**

to Run a container from docker file : **docker run -dit --name=mydesktop -p 3389:3389 hosdeburgh2/ubuntu-desktop:latest**

to connect to image through remote desktop : use windows rdp with this address : 127.0.0.1:3389 and following info:
user:scott
pass:testing

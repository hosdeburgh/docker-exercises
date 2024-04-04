Following steps was done to create nexus image :

1.Since installation of openjkd takes a long time, first and image called ubuntu:latest was pulled from docker hub,
   openjdk was install on this image and finally an image was created with the name of ubuntu-jdk:latest from this image
   
2.  The initial installation of Nexus took place on a local virtual machine, with guidance obtained from the following resource :
   https://www.howtoforge.com/how-to-install-nexus-repository-manager-on-ubuntu-22-04/

3. Two folders named **nexus** and **sonatype-work** were created and necessary config was done inside this folders

4. A folder called nexus was created and **nexus**,**sonatype-work** and **dockerfile** were placed inside this folder
   
5. finally using this command "**docker build -t nexus .**" the nexus image was created.
   The final image can be pulled from docker hub using this command
   **docker pull hosdeburgh2/nexus:latest**
   
6. to run a container from this image use this command : **docker run -dit --name nexus-app -p 8081:8081 hosdeburgh2/nexus:latest**

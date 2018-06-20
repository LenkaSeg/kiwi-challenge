Kiwi weekend in the cloud task! I learned about this weekend just after the deadline, but decided 
to solve it anyways. It sounds interesting and is aimed at exactly what I wanted to learn! It 
took me exactly one month and one week of time and I learned all this and much more from my husband and 
people from codebar.io/barcelona. Thanks to all!

==================================================================
Run:
    ./gen_cert.sh 
to generate certificate and key.
    sudo docker build -t lenkaseg/kiwi
to build a docker image
    sudo docker run -p 5000:5000 -v /home/lenka/Documents/code/kiwi/certs:/etc/nginx/certs --name kiwi lenkaseg/kiwi
to run a docker container

===================================================================

Dockerhub image available at https://hub.docker.com/r/lenkaseg/kiwi/

docker pull lenkaseg/kiwi

===================================================================

TASK:

As your entry task, we'd like you to provide us with a built and working 
Docker image.
You can share your code with us via repo. BONUS: multiple logical 
commits are preferable to just one.
Requirements

- A simple html site, with the title "I want to attend the Kiwi.com 
Weekend in the Cloud"
  - A simple site will be enough, but feel free to get creative.
- Use Nginx as your web server
  - BONUS: use SSL
  - Hint: use Let's Encrypt
  - https://letsencrypt.org/docs/certificates-for-localhost/
- Use Docker Hub to build and share your image

==================================================================

DOCKER

How to install docker:
    sudo pacman -S docker

How to create a container:
- make a Dockerfile (looks a bit like Vagrantfile) - in the same directory where I want the
container

Dockerfile:
- FROM: I'm using nginx:alpine, it felt more appropriate when using nginx 
-  chown mean change owner, -R flag means recursively:
    chown name -R /some/path means, that the operation will be performed for all files and
directories(and all files and directories within directory). So it will change the file owner to
name for all files and directories in /some/path
- COPY: where the copy is in Dockerfile is very important. If it's in the beginning, docker will
rebuild that and following layers. Thus, when coding, it's better to have COPY just nefore
ownership change. Run can be split into more. When Dockerfile changes, build will rebuild all the
layers from that point on.

    sudo systemctl enable docker
    sudo systemctl start docker

    docker build -t [username]/[container name]
       
example: 

    docker build -t lenkaseg/kiwi . 
          
Note: that dot there in the end is very important

    sudo usermod -aG docker lenka
    sudo docker run lenkaseg/kiwi
    
After every change build and run docker again.

docker ps = listing all the containers

THIS IS VERY IMPORTANT:
    docker inspect 799a1d21208b | grep 172
inspect = searches through the container of this ID
piping = "|" = grabs the result and prints it
grep = prints just the lines which contain 172

    sudo docker inspect 799a1d21208b | less = opens a file with configuration

TO USE ALL THIS COMMANDS THE DOCKER HAS TO BE RUNNING (SUDO DOCKER RUN + PATH)

    man Dockerfile 
= show dockerfile manual

IP ADRESS/PORT
    sudo docker run -p 5000 lenkaseg/kiwi

write to Dockerfile: EXPOSE 5000

I'm telling docker, that port 5000 is the port 5000 I want it to run the stuff on:
    sudo docker run -p 5000:5000 lenkaseg/kiwi

to see all the docker images:
    docker images -a

How to structure work into containers:
- every functionality should have its own container (like login, forum, ... - like a complete
element with its static and templates). Then a Docker Compose (or Kubernetes) runs it all
together, and when some of the containers needs to be put down, it doesn't affect the rest of the
app.

===============================================================================================

NGINX

- put the site.html where nginx expects them to be and change the entrypoint in the dockerfile
and  build and run the docker
	and this is exactly the how it is done:
    COPY site.html /usr/share/nginx/html
copies [what] [to where]

==============================================================================================

SSL
I followed the link in the task: https://letsencrypt.org/docs/certificates-for-localhost/
I ran these commands:
-From the link mentioned above:
    openssl req -x509 -out localhost.crt -keyout localhost.key \
  -newkey rsa:2048 -nodes -sha256 \
  -subj '/CN=localhost' -extensions EXT -config <( \
   printf "[dn]\nCN=localhost\n[req]\ndistinguished_name = 
dn\n[EXT]\nsubjectAltName=DNS:localhost\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth")

- to mount the path from the host to the container, to point out where the certificates are, 
using this -v which stands for volume:
    sudo docker run -p 5000:5000 -v /home/lenka/Documents/code/kiwi/certs:/etc/nginx/certs \
lenkaseg/kiwi

It was not running well in Chrome, but in Firefox yes.

=============================================================================================

some more magic

- to clean up a bit all the mess of docker images I made along the process:
    sudo docker ps --all
    sudo docker inspect [container id]
    sudo docker start [container id] 
= in case I killed or stopped some container and I want to run exactly the same. 
If I would use run, it would create another container.
    sudo docker stop [container id] 
= or kill. Just stops the container.

- some command line magic for removing all the old containers (because they take space), called piping
    sudo docker ps --all 
= lists all the containers
    sudo docker ps --all | cut -f1 -d' ' 
= cut all the columns except the one I need. -d means 
delimiter = the separator
    sudo docker ps --all | cut -f1 -d' ' | grep -v CONTAINER 
= keep all the lines except of that one mentioned "CONTAINER"
    sudo docker ps --all | cut -f1 -d' ' | grep -v CONTAINER | xargs sudo docker rm 
= xargs converts column into row and passes it to the following command - which removes them all

- to run the container with this volume settings and naming it kiwi:
    sudo docker run -p 5000:5000 -v /home/lenka/Documents/code/kiwi/certs:/etc/nginx/certs --name \
kiwi lenkaseg/kiwi
= and then I don't use run if I don't change it, only start and stop = I'm running the same 
container, not creating a new one every time

And every time I change something in Dockerfile or other related files, I have to build another image. 
On top of this image, as it's instance, I can run containers.
To see the docker images:
    sudo docker images

When I have a tested image, I can name it, to have it easier later to return to it:
    sudo docker tag lenkaseg/kiwi:latest lenkaseg/kiwi:rememberme
or
    sudo docker tag 26a7e99c9842 lenkaseg/kiwi:latest

================================================================================================

PERMISSIONS
    ls -l 
= exposes the permissions for listed files = Read, Write, eXecute
To make file executable: 

    chmod u+x gen_cert.sh

.sh files are looked for only in these paths: 

    echo $PATH

To make them be executable from current directory, add ./

    ./gen_cert.sh

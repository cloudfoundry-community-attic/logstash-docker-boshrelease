Develop your own Elastic Search and Logstash Dockerfile
=======================================================

This folder is for you to iterate and develop on your own Logstash configuration customizations, without having to rebuild the 900Mb `cfcommunity/logstash` image.

Usage
-----

### Build the image

To create the image `USERNAME/logstash`, execute the following command in this `image` folder:

```
$ export DOCKER_USER=<you>
$ docker build -t $DOCKER_USER/logstash .
```

This is super quick to iterate:

```
Sending build context to Docker daemon 6.656 kB
Sending build context to Docker daemon
Step 0 : FROM cfcommunity/logstash
 ---> 589dac296411
Step 1 : MAINTAINER You
 ---> Running in 72d071bdb07b
 ---> f7aa51ba762d
Removing intermediate container 72d071bdb07b
Step 2 : ADD etc/logstash/logstash.conf /etc/logstash/logstash.conf
 ---> 1011dcd592a7
Removing intermediate container 047e3ddce65e
Successfully built 1011dcd592a7
```

Your extended image sits along side the upstream image:

```
$ docker images
REPOSITORY                   TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
drnic/logstash               latest              1011dcd592a7        2 minutes ago       885.9 MB
cfcommunity/logstash         latest              589dac296411        15 minutes ago      885.9 MB
```

To push the image to your Docker Hub registry account:

```
$ docker push $DOCKER_USER/logstash
```

### Run the image

To run the image and bind to host port 514, 9200, 9300:

```
$ docker run -d --name logstash -p 514:514 -p 9200:9200 -p 9300:9300 $DOCKER_USER/logstash
```

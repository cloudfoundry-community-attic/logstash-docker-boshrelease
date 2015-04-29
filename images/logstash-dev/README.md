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

To push the image to your Docker Hub registry account:

```
$ docker push $DOCKER_USER/logstash
```

### Run the image

To run the image and bind to host port 514, 9200, 9300:

```
$ docker run -d --name logstash -p 514:514 -p 9200:9200 -p 9300:9300 $DOCKER_USER/logstash
```

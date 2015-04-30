Develop your own Elastic Search and Logstash Dockerfile
=======================================================

This folder is for you to iterate and develop on your own Logstash configuration customizations, without having to rebuild the 900Mb `cfcommunity/logstash` image.

It is also published upstream as `cfcommunity/logstash-dev`, and is the image deployed when running:

```
./templates/make_manifest warden container upstream
```

It includes Kibana 4 running on port 5601.

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

### bosh-lite

If you run `cfcommunity/logsearch-dev` or your own version, then Kibana 4 is included.

If you are running it in bosh-lite then you'll need to map its port `5601` to the host VM:

From the `bosh-lite` project:

```
vagrant ssh -c 'sudo iptables -t nat -A PREROUTING -p tcp -d $(curl -s http://169.254.169.254/latest/meta-data/local-ipv4) --dport 5601 -j DNAT --to 10.244.8.2:5601'
```

Or from inside your bosh-lite VM:

```
sudo iptables -t nat -A PREROUTING -p tcp -d $(curl -s http://169.254.169.254/latest/meta-data/local-ipv4) --dport 5601 -j DNAT --to 10.244.20.6:5601
```

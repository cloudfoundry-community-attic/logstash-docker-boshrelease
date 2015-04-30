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

To build & use Docker images you will need an account with Docker https://hub.docker.com/account/signup/. Your account name replaces `<you>` below.

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

Push the image to your Docker Hub registry account:

```
$ docker push $DOCKER_USER/logstash
```

### Run the image locally

To run the image and bind to host port 514 (syslog), 9200, 9300, 5601 (kibana4):

```
$ docker run -d --name logstash -p 514:514 -p 9200:9200 -p 9300:9300 -p 5601:5601 $DOCKER_USER/logstash
```

### Setup bosh-lite

The the `logstash-dev` `Dockerfile` includes Kibana 4 which runs on port 5601. To access this thru bosh-lite involves adding a port route to the host VM.

From the `bosh-lite` project:

```
vagrant ssh -c 'sudo iptables -t nat -A PREROUTING -p tcp -d $(curl -s http://169.254.169.254/latest/meta-data/local-ipv4) --dport 5601 -j DNAT --to 10.244.20.6:5601'
```

Or from inside your bosh-lite VM:

```
sudo iptables -t nat -A PREROUTING -p tcp -d $(curl -s http://169.254.169.254/latest/meta-data/local-ipv4) --dport 5601 -j DNAT --to 10.244.20.6:5601
```

### Run your custom Docker image in a BOSH VM on bosh-lite

Create an override YAML file, say `my-docker-image.yml`

```yaml
---
meta:
  logstash_image:
    image: <you>/logstash
    tag: latest
```

From the root of this project:

```
./templates/make_manifest warden container upstream my-docker-image.yml
bosh -n deploy
```

You can now view Kibana4 at port 5601 on the host VM (same IP as `bosh target`).

If you make any changes to your `images/logstash-dev/etc/logstash/logstash.conf` and want to redeploy it.

From the `images/logstash-dev` folder:

```
export DOCKER_USER=<you>
docker build -t $DOCKER_USER/logstash .
docker push $DOCKER_USER/logstash
bosh -n delete deployment logstash-docker-warden
bosh -n deploy
```

Pull requests
-------------

If you want to submit a pull request to `cfcommunity/logstash` image, please copy your `images/logstash-dev/etc/logstash/logstash.conf` changes into `images/logstash/etc/logstash/logstash.conf`.

Submit the PR for simulteaneous changes to both `images/logstash` and `images/logstash-dev` to keep them in sync.

Elastic Search and Logstash Dockerfile
======================================

A Dockerfile that produces a Docker Image for [Logstash](logstash.net) and [ElasticSearch](https://www.elastic.co/), with default Logstash configuration for Cloud Foundry application logs.

Usage
-----

### Build the image

To create the image `cfcommunity/logstash`, execute the following command in this `image` folder:

```
$ docker build -t cfcommunity/logstash .
```

To push the image to the `cfcommunity` org:

```
$ docker push cfcommunity/logstash
```

### Run the image

To run the image and bind to host port 514, 9200, 9300:

```
$ docker run -d --name logstash -p 514:514 -p 9200:9200 -p 9300:9300 cfcommunity/logstash
```

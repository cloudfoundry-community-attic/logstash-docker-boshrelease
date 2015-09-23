BOSH Release for Logstash/Elastic Search in Docker container
============================================================

This BOSH release has three use cases:

-	run a single Docker container of a Logstash/ES Docker image on a single BOSH VM
-	run a Cloud Foundry service broker that itself runs containers of Logstash/ES Docker image on a BOSH VM based on user requests
-	embedded Logstash/ES Docker image that could be used by another BOSH release

The Logstash/Elastic Search image can be referenced either:

-	from an embebbed/bundled image stored with each BOSH release version
-	from upstream and/or private registries

[Learn more](https://blog.starkandwayne.com/2015/04/28/embed-docker-into-bosh-releases/) about embedding Docker images in BOSH releases.

Installation
------------

To use this BOSH release, first upload it to your bosh and the `docker` release

```
bosh upload release https://bosh.io/d/github.com/cf-platform-eng/docker-boshrelease
bosh upload release https://bosh.io/d/github.com/cloudfoundry-community/logstash-docker-boshrelease
```

For the various Usage cases below you will need this git repo's `templates` folder:

```
git clone https://github.com/cloudfoundry-community/logstash-docker-boshrelease.git
cd logstash-docker-boshrelease
```

Usage
-----

### Run a single container of Logstash/ES

For [bosh-lite](https://github.com/cloudfoundry/bosh-lite), you can quickly create a deployment manifest & deploy a single VM:

```
templates/make_manifest warden container embedded
bosh -n deploy
```

This deployment will look like:

```
$ bosh vms logstash-docker-warden
+----------------------+---------+---------------+--------------+
| Job/index            | State   | Resource Pool | IPs          |
+----------------------+---------+---------------+--------------+
| logstash_docker_z1/0 | running | small_z1      | 10.244.18.10 |
+----------------------+---------+---------------+--------------+
```

If you want to use the upstream version of the Docker image, reconfigure the deployment manifest:

```
templates/make_manifest warden container upstream
bosh -n deploy
```

To register your Logstash with a Cloud Foundry application on bosh-lite/warden:

```
cf cups logstash -l syslog://10.244.18.10:514
```

Now bind it to your applications and their STDOUT/STDERR logs will automatically stream to your Logstash.

```
cf bs my-app logstash
```

### Run a Cloud Foundry service broker for Logstash/ES

For [bosh-lite](https://github.com/cloudfoundry/bosh-lite), you can quickly create a deployment manifest & deploy a single VM that also includes a service broker for Cloud Foundry

```
templates/make_manifest warden broker embedded
bosh -n deploy
```

This deployment will also look like:

```
$ bosh vms logstash-docker-warden
+----------------------+---------+---------------+--------------+
| Job/index            | State   | Resource Pool | IPs          |
+----------------------+---------+---------------+--------------+
| logstash_docker_z1/0 | running | small_z1      | 10.244.18.10 |
+----------------------+---------+---------------+--------------+
```

As a Cloud Foundry admin, you can register the broker and the service it provides:

```
cf create-service-broker logstash-docker containers containers http://10.244.18.10
cf enable-service-access logstash14
cf marketplace
```

If you want to use the upstream version of the Docker image, reconfigure the deployment manifest:

```
templates/make_manifest warden container upstream
bosh -n deploy
```

### Using Cloud Foundry Service Broker

Users can now provision logstash services and bind them to their apps.

```
cf cs logstash14 free my-logs
cf bs my-app my-logs
```

The invisible logstash service will start having all app logs drained to it automatically by Cloud Foundry.

To see the logs, please investigate the [kibana-me-logs CLI plugin](https://github.com/cloudfoundry-community/cf-plugin-kibana-me-logs)

### Override security groups

For AWS & Openstack, the default deployment assumes there is a `default` security group. If you wish to use a different security group(s) then you can pass in additional configuration when running `make_manifest` above.

Create a file `my-networking.yml`:

```yaml
---
networks:
  - name: logstash-docker1
    type: dynamic
    cloud_properties:
      security_groups:
        - logstash-docker
```

Where `- logstash-docker` means you wish to use an existing security group called `logstash-docker`.

You now suffix this file path to the `make_manifest` command:

```
templates/make_manifest aws-ec2 container embedded my-networking.yml
bosh -n deploy
```

### Versions & configuration

The version of Logstash/Elastic Search is determined by the Docker image bundled with the release being used. The source for building the Docker image is in the `images/logstash` folder of this repo. See below for instructions.

The Logstash filters used to parse incoming logs is also determined by the Docker image.

### Development of logstash configuration

To push new ideas/new logstash filters to an alternate Docker Hub image name:

```
cd images/logstash-dev
export DOCKER_USER=<your user>
docker build -t $DOCKER_USER/logstash .
docker push $DOCKER_USER/logstash
```

This will create a new Docker image, based upon the upstream `cfcommunity/logstash`.

You can now try out new logstash configuration in `images/logstash-dev/etc/logstash/logstash.conf` and re-build/push the image quickly.

You can now test them using `upstream` templates.

Create an override YAML file, say `my-docker-image.yml`

```yaml
---
meta:
  logstash_image:
    image: USERNAME/logstash
    tag: latest
```

To deploy this change into BOSH, add the `my-docker-image.yml` file to the end of the `make_manifest` command:

```
./templates/make_manifest warden container upstream my-docker-image.yml
bosh deploy
```

### Development of releases

To recreate the Docker image that hosts Logstash & Elastic Search and push it upstream:

```
cd image
docker build -t cfcommunity/logstash .
```

To package the Docker image back into this release:

```
bosh-gen package logstash --docker-image cfcommunity/logstash
bosh upload blobs
```

To create new development releases and upload them:

```
bosh create release --force && bosh -n upload release
```

### Final releases

To share final releases, which include the `cfcommunity/logstash` docker image embedded:

```
bosh create release --final
```

By default the version number will be bumped to the next major number. You can specify alternate versions:

```
bosh create release --final --version 2.1
```

After the first release you need to contact [Dmitriy Kalinin](mailto://dkalinin@pivotal.io) to request your project is added to https://bosh.io/releases (as mentioned in README above).

BOSH Release for Logstash/Elastic Search in Docker container
============================================================

Usage
-----

To use this BOSH release, first upload it to your bosh and the `docker` release

```
bosh upload release https://bosh.io/d/github.com/cf-platform-eng/docker-boshrelease
bosh upload release https://bosh.io/u/github.com/cloudfoundry-community/logstash-docker-boshrelease
```

For [bosh-lite](https://github.com/cloudfoundry/bosh-lite), you can quickly create a deployment manifest & deploy a cluster:

```
git clone https://github.com/cloudfoundry-community/logstash-docker-boshrelease.git
cd logstash-docker-boshrelease
templates/make_manifest warden
bosh -n deploy
```

For AWS EC2, create a single VM:

```
git clone https://github.com/cloudfoundry-community/logstash-docker-boshrelease.git
cd logstash-docker-boshrelease
templates/make_manifest aws-ec2
bosh -n deploy
```

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
templates/make_manifest openstack-nova my-networking.yml
bosh -n deploy
```

### Development

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

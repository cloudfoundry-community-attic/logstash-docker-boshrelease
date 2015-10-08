Pipeline to build images
========================

Update pipeline
---------------

```
fly -t snw c logstash-docker-images -c ci/pipeline.yml --vf ci/credentials.yml
```

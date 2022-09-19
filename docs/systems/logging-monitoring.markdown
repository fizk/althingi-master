---
layout: page
title: Logging and Monitoring
permalink: /systems/logging-monitoring
---

Collections of containers and services to log and monitor the entire system.

## What is it?
This is mostly the [ELK stack](https://www.elastic.co/elastic-stack/) configured to listen to logs and event from different systems.

Metricbeat is listening to Docker containers. Filebeat is listening for logs coming out of Docker's `stdOut`. Everything is collected into Logstash where it is formatted before being sent to Elasticsearch. Kibana is then used as a UI.


## Running the service
To run the monitoring service, simply run the docker-compose file:

```sh
docker compose up elasticsearch kibana metricbeat filebeat logstash -d
```

Now the monitor system is up and running, but Kibana does not have the required dashboards and search indexes. Do do that, the _metricbeat setup_ process has to be run. For it to run within the correct network, the docker-compose file is used.

```sh
docker compose run --rm metricbeat bash -c "metricbeat setup -E setup.kibana.host=kibana:5601 -E output.elasticsearch.hosts=[\"elasticsearch:9200\"]"
```

You might need to wait a bit until Elastic comes on line. So if it says that Elasticsearch can't be connected to, just wait and then retry.

Update network names and ports accordingly.

## Monitor dashboard
This docker-compose file exposes one port, **8081** which is where Kibana keeps it dashboards.


## Bootstrapping search
Elasticsearch needs indexes defined before accepting input. A cURL command can be run to populate Elastic search with the required index-mapping. This repo contains a docker-container which its only purpose it to run once, send a cURL instruction and exit.

When this docker-image is built, it wil copy the payload required to run the cURL (json files) and then set up a shell-script to make the actual HTTP call (via cURL). It then puts the shell-script (called `init.sh`) in the `CMS` command of the Dockerfile.

Because the shell-script is going to connect to a remote server/service (in this case the Elasticsearch cluster), it needs to know where to locate server. Pass in a environment variable to set Elasticsearch host and port, for example:

```sh
docker build -f Dockerfile.init -t search-init .

docker run -it -e MONITOR_ES=elasticsearch:9200 search-init
// or
docker run -it -e MONITOR_ES=host.docker.internal:9200 search-init
```

| VAR        | TYPE           | DEFAULT             | DESCRIPTION                                                    |
| ---------- | -------------- | ------------------- | -------------------------------------------------------------- |
| MONITOR_ES | <host>:<port>  | elasticsearch:9200  | The host and port of Elasticsearch that hosts the monitor logs |
| SEARCH_ES  | <host>:<port>  | elasticsearch:9200  | The host and port of Elasticsearch that hosts the search logs  |
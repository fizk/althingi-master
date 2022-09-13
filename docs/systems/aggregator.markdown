---
layout: page
title: Aggregator
permalink: /systems/aggregator
---

The Aggregator is a CLI program meant to run on a regular interval, maybe with the aid of a cron job. Its purpose is to fetch data from the [Althingi XML feed](https://www.althingi.is/altext/xml/), format it, validate it, and pass it onto a system that will store it. That would be the [Source system](/systems/source).

## Running
Since it's best to run this system in a Docker container, I will explain the system from a Docker's point of view.

The Dockerfile allows the system to be run in two modes: `production` and `non-production`. When Building the docker image specify a `--build-arg` to be either `production` or `development`.

```sh
$ docker build  -t aggregator --build-arg=production .
```

## Production

## Development
See [development section](/development/producer#aggregator)




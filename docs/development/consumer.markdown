---
layout: page
title: Development |> Consumer Systems.
permalink: /development/consumer
---

To be able to develop the _consumer_ part of the system, the _provider_, aggregator and queues don't need to be running. The repos are set up in such a way that when run, they can be developed.

This is made possible by injecting env-argument and build-arguments that expose the services to the host system. All traffic goes through the host system's localhost. Therefor, all system and services are accessible through various external debugging and monitoring tools running on the host operating system.

All the repos have a docker-compose file that has a `run` service. Each of these service expose the system/service to the host system and each system that has a dependency on another system will then access the dependency through the localhost domain.

The system in question are

* Store
    - store database
* Server
* Client

<svg style="height=25%; width:25%" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 302 405">
  <g fill="none" fill-rule="evenodd">
    <path d="M216 35v28h-63v-9.1l-7 6.9v-8.7h-34V123h59v6.1h29v-8.7l7 7V118h63v28h-63v-9.1l-7 7V135h-29V181h-26.4l7.1 7.1H143V222h28v58h-30.9v41H166a5 5 0 0 1 5 5v48a5 5 0 0 1-5 5H48a5 5 0 0 1-5-5v-48a5 5 0 0 1 5-5h39v-34h-8.7l7-7H43v-58h94v-33.9h-8.7l7.1-7.1H43v-58h63V46h40v-8.7l7 7V35h63Zm-81.9 245H94.7l7 7H93v34h41.1v-41Z" stroke-opacity=".8" stroke="#262626" stroke-width="2" fill="#FFF"/>
    <text font-family="Helvetica-Bold, Helvetica" font-size="12" font-weight="bold" fill="#555353">
            <tspan x="42" y="115">server</tspan>
        </text>
    <text font-family="Helvetica-Bold, Helvetica" font-size="12" font-weight="bold" fill="#555353">
            <tspan x="153" y="28">store</tspan>
        </text>
    <text font-family="Helvetica-Bold, Helvetica" font-size="12" font-weight="bold" fill="#555353">
            <tspan x="206" y="111">search</tspan>
        </text>
    <text font-family="Helvetica-Bold, Helvetica" font-size="12" font-weight="bold" fill="#555353">
            <tspan x="42" y="214">client</tspan>
        </text>
    <path stroke="#474747" stroke-width="2" fill="#FFF" d="M80 233h82v36H80z"/>
    <text transform="rotate(-90 71 251)" font-family="Helvetica-Bold, Helvetica" font-size="12" font-weight="bold" fill="#555353">
            <tspan x="50" y="255">apache</tspan>
        </text>
    <text font-family="Helvetica-Bold, Helvetica" font-size="12" font-weight="bold" fill="#555353">
            <tspan x="121" y="247">proxy</tspan>
        </text>
    <path d="m137.1 250.4-11.7 11.7h8.7v12h6v-12h8.8L137 250.4Z" stroke="#474747" stroke-width="2" fill="#FFF"/>
    <circle stroke="#474747" fill="#FFF" cx="162" cy="329" r="2.5"/>
    <circle stroke="#474747" fill="#FFF" cx="154" cy="329" r="2.5"/>
    <circle stroke="#474747" fill="#FFF" cx="146" cy="329" r="2.5"/>
    <text transform="rotate(-90 100 312)" font-family="Helvetica-Bold, Helvetica" font-size="8" font-weight="bold" fill="#555353">
            <tspan x="97" y="315">/*</tspan>
        </text>
    <text transform="rotate(-90 147 301)" font-family="Helvetica-Bold, Helvetica" font-size="8" font-weight="bold" fill="#555353">
            <tspan x="131" y="304">/graphql</tspan>
        </text>
  </g>
</svg>


The **Store** exposes port `8083` and the database is exposed on `27017`. `docker compose up run` maps the source directory into the container so any changes will be reflected into the running application

The **Server** exposes port `3000` and it sets an env variable `STORE_URL` to `http://${DOCKER_GATEWAY_HOST:-host.docker.internal}:8083` which in turn accesses the Store through the host system localhost on port `8083`.
The Server's `docker compose up run` is configured with `denon`, so it will reload the Server every time a changes are made. `docker compose up run` maps the source directory into the container so any changes will be reflected into the running application

The **Client** exposes port `8282` as well as setting a build-argument `API_HOST` to `http://${DOCKER_GATEWAY_HOST:-host.docker.internal}:3000` so that the Apache server can proxy requests to the Server.


---
layout: page
title: Client
permalink: /systems/client
---

The **Client** is the Interface of the **Loggjafarthing** application.

It is a SPA (SinglePageApplication) written in React, and an Apache HTTP server configured to serve up HTML, CSS and Javascript. It also serves as a gateway to backend services, the Store and the ImageServer (Thumbor). The React applications uses GraphQL to as it data-source protocol, and the Apollo Client to manage GraphQL queries and caching.

I think it's best to look at the overall architecture before we dive into the technicals, it will make things simpler when we go into the details.

When the browser requests a page in the app, Apache will serve up a skeleton HTML page which requests JS and CSS files. The browser will make additional HTTP requests for these resources. In production, when the initial HTTP page is requested, Apache will send a preload header along with the response so the browser can start fetching the JS and CSS files before it's able to start parsing the skeleton HTML page. This just saves valuable microseconds.

Once the JS file has been downloaded and parsed, the application start to run, one of the first thing is sees is a GraphQL query for data. The Apollo Client will make a request back to the server through the `/graphql` endpoint. When Apache sees this request, it will use the _ProxyPass_ plugin to forward that request onto the **Server**. The server will make a request to the **Store** to fetch the data and then data will travel the same way back to the client/browser.

Once the data has been rendered in the browser, there might be some images required, most often, an avatar of a person. The URL will always start with a `/myndir`. When Apache sees this, it will again use _ProxyPass_ to forward that to Thumbor to fetch images.

![server / client](/assets/images/server-client.svg)

The _ProxyPass_ plugin provides a internal router so to say, it will receive the HTTP request and will decide if it should fetch images from Thumbor, static JS/CSS file from its own storage or relay the request to the Server for data.

The Client is also responsible for hiding all the back-end services from the end-user.
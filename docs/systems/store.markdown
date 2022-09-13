---
layout: page
title: Store
permalink: /systems/store
---

### Unit test
I often like to open up a `test` container in bash mode and run unit-test from there.

```sh
$ docker compose run --rm test bash
```

Once inside the container, one can simply run

```sh
$ phpunit --filter=someTestMethod ./test/
```

To make things simple, there is an alias to run tests and generate a code-coverage report:

```sh
$ cover ./test/
```

The report will be generated inside the `./test` folder.

### Export data.

```sh
$ docker exec local-althingi-store-db sh -c 'exec mongodump -u root -p example  -d althingi --authenticationDatabase=admin --archive' > ./althingi.archive
```
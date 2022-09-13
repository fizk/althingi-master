---
layout: page
title: Source
permalink: /systems/source
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

To make a dump of the database, run
```sh
docker exec CONTAINER /usr/bin/mysqldump -u root --password=example althingi > path/to/backup.sql
```

To import dump into the database
```sh
docker exec -i CONTAINER mysql -u root --password=example althingi < path/to/backup.sql
```

docker exec -i local-althingi-source-db mysql -u root --password=example althingi <
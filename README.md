## Smart Email Marketing

A simple dockerized app to manage your emails and campaigns with taggings.

## Features

**Email Campaign Management:**

* Import users from csv
* Add custom data to users
* User's tagging and camaign's tagging
* Filter users with advanced search and create a camaign from filtered result
* Email templates
* Email stats from sendgrid
  
## Installation
Install the most recent version of the Docker Engine for your platform using the [official Docker releases](http://docs.docker.com/engine/installation/), which can also be installed using:

```bash
wget -qO- https://get.docker.com/ | sh
```
    
Install docker compose from the [official page](https://docs.docker.com/compose/install/).    

Copy the `docker-compose.yml` from this project to under new directory in your system.
   
Change `/your/db/store/path`, `yourhost.com` and `yourSercretKeyBase` with your own.
   
```yml

  web:
    image: mojilala/smart-emailing:latest
    volumes:
      - /your/db/store/path:/var/db
    environment:
      VIRTUAL_HOST: yourhost.com
      SECRET_KEY_BASE: yourSercretKeyBase
```   
then run:
   
```bash

docker-compose run web rake db:migrate

docker-compose up -d
```



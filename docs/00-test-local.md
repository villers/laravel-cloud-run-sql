# Try the application locally

*Before you get to deploying this application on Google Cloud, you can test the application locally with Docker and Docker Compose.*

*In this section, we'll build the application on our local machine, and using the provided configuration file, we'll deploy the app locally.*

---

You will need to install: 

 * Docker Desktop
   * for Windows or macOS: use [Docker Desktop](https://www.docker.com/products/docker-desktop) 
   * for Linux: use [Docker CE](https://docs.docker.com/install/) ([Ubuntu](https://docs.docker.com/install/linux/docker-ce/ubuntu/), [Debian](https://docs.docker.com/install/linux/docker-ce/debian/), [CentOS](https://docs.docker.com/install/linux/docker-ce/centos/), and [Fedora](https://docs.docker.com/install/linux/docker-ce/fedora/) have dedicated instructions)
 * [Docker Compose](https://docs.docker.com/compose/install/#install-compose)

This local deployment will use the same image as our production deployment will, but will make use of the included `docker-compose.yml` to connect together the components. 

## Get a local copy of the code

If you are familiar with `git`: 

```
git clone git@github.com:villers/laravel-cloud-run-sql.git
cd laravel-cloud-run-sql
```

## Build the image
 
Before we can use our image, we have to build it. The database image will be pulled down later, so we just need to manually build our web image: 

```
docker-compose build
``` 


## Initialise the database

At the moment the database is empty. We can use standard django commands to run our database migrations, and add some default data; these instructions need to be run the context of our web image: 

```
docker-compose run --rm app php artisan migrate --seed
```

## Start the services

Now we have a database, and a build web image, we can start them: 

```
docker-compose up
``` 

You can now see app running in your browser at [http://localhost:8080/](http://localhost:8080/)

---

Next step: [Setup Google Cloud Platform environment](10-setup-gcp.md)

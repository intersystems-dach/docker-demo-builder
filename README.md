# InterSystems IRIS Docker Image Builder

This project aims to simplify the creation of docker based InterSystems IRIS demos.

## How to use

### Preparation

Clone this repository to your local machine. Edit the configuration in `config.sh` according to your requirements. Create a new folder in `./projects` which will contain your project files. Inside this folder, create a new script called `iris.script`. This file must contains objectscript commands and will be called during the Docker build process (make sure to start each line with at least one whitespace character). It is used to import, compile and configure your project. Take a look at the example projects `projects/INTEROP_DEMO` and `projects/COMSRV_DEMO`. Those should be removed before creating your docker container. Alternatively, you can rename the `iris.script` in the demo folders to e.g. `iris.script.old`.

### InterSystems container repository login

If you are using InterSystems container registry images, you must log in to the InterSystems container repository before running `setup.sh`. Go to [containers.intersystems.com](https://containers.intersystems.com), log in, get your Docker login command and run it in a terminal on your local machine. It should look like this:

```bash
docker login -u="user" -p="xyz123..." containers.intersystems.com
```

### Build image and create the container

1. Open a terminal and change the directory to the root of this repository.
2. Run `./setup.sh`. 
3. By default the script will ask you if you want to export the image. This enables you to move the demo to another machine or share it with others. 

WARNING: Depending on your configuration the image might contain a license file that you don't want to share with others.

### Create container on another system

After building your and exporting the container image, collect the image file (e.g `your-image.tgz`) and the `docker-compose.yml` file. Copy the files to the destination system. Open a terminal on the destination system, and change the directory to where the `docker-compose.yml` and `your-image.tgz` are located. To import the image run:

```bash
docker load  < your-image.tgz
``` 

Then create the container:

```bash
docker compose up -d
```





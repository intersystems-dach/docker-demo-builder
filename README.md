# InterSystems IRIS Docker Demo Builder

This is a template project to create InterSystems IRIS docker demos. It supports InterSystems IRIS and IRIS for Health, both the Standard and the Community Edition. The web gateway will always have SSL enabled, the setup script can generate a self-signed certiificate or obtain a valid certificate via Let's Encrypt. Persistent volumes will be mounted from `./volumes/iris` to `<iris-container>:/iris-shared` and `./volumes/webgateway` to `<webgateway-container>:/webgateway-shared`. `Durable %SYS`is not used by default and must be added manually to `docker-compose.yaml`. This template include two sample projects. Have a look at `./projects` for details.

## Running a demo project

1. Clone repository
2. Log in to the InterSystems container repository if required.
3. Edit `.env`
4. Run `./setup.sh`

On a Windows machine use `WSL` oder `git bash`. If you want to use Let's encrypt certificates make sure to configre a publicly resolvable FQDN as `WEBGATEWAY_HOSTNAME` and that port 80 is accessible from the Internet. Let's encrypt is only supported on a Linux (and probably WSL2) machine that has snapd installed. 

## InterSystems container repository login

If you are using InterSystems container registry images, you must log in to the InterSystems container repository before running `setup.sh`. Go to [containers.intersystems.com](https://containers.intersystems.com), log in, get your Docker login command and run it in a terminal on your local machine. It should look like this:

```bash
docker login -u="user" -p="xyz123..." irepo.intersystems.com
```

## Creating a demo project

Clone the template project to your local machine. Edit the configuration in `.env` according to your requirements. Create a new folder in `./projects` which will contain your project files. Inside this folder, create a new script called `iris.script`. This file must contains objectscript commands and will be called during the Docker build process (make sure to start each line with at least one whitespace character). It is used to import, compile and configure your project. Optionally, you can also create a bash script called `prepare.sh`. It is called before the execution of `iris.script`. Take a look at the example projects `projects/INTEROP_DEMO` and `projects/COMSRV_DEMO`. Those example porjects should be removed before creating your docker container. Alternatively, you can rename the `iris.script` in the demo folders to e.g. `iris.script.old`.



---
title: "Single-User&#58 Install on Docker"
keywords: docker, installation
tags: [installation, docker]
sidebar: user_sidebar
permalink: docker.html
folder: setup
---

## Pre-Requisites

* Docker 11.1+ (Docker 1.13+ recommended, ideally the [latest Docker version](http://docs.docker.com/engine/installation/))

```bash
wget -qO- https://get.docker.com/ | sh
```

* OS: Linux, MacOS, Windows
* Min 1 CPU, 2GM RAM, 3GB disc space


The default port required to run Che is `8080`. Che performs a preflight check when it boots to verify that the port is available. You can pass `-e CHE_PORT=<port>` in Docker portion of the start command to change the port that Che starts on.

Internal ports are ports within a local network. This is the most common scenario for most users when Che is installed on their local desktop/laptop. External ports are ports outside a local network. An example scenario of this would be a remote Che server on a cloud host provider. With either case ports need to be open and not blocked by firewalls or other applications already using the same ports.

All ports are TCP unless otherwise noted.

|Port >>>>>>>>>>>>>>>>|Service >>>>>>>>>>>>>>>>|Notes|
|---|---|---|
|5000|Keycloak Port|Multi-user only
|8080|Tomcat Port| Che server default port
|8000|Server Debug Port|Users developing Che extensions and custom assemblies would use this debug port to connect a remote debugger to Che server.
|32768-65535|Docker and Che Agents|Users who launch servers in their workspace bind to ephemeral ports in this range. This range can be limited.

## Known Issues

You can search Che's GitHub issues for items labeled `kind/bug` to see [known issues](https://github.com/eclipse/che/issues?q=is%3Aissue+is%3Aopen+sort%3Aupdated-desc+label%3Akind%2Fbug).

There are two known issues where features work on Docker 1.13+, but do not on Docker 1.12:

* SELinux: [https://github.com/eclipse/che/issues/4747](https://github.com/eclipse/che/issues/4747)
* `CHE_DOCKER_ALWAYS__PULL__IMAGE`: [https://github.com/eclipse/che/issues/5503](https://github.com/eclipse/che/issues/5503)

Sometimes Fedora and RHEL/CentOS users will encounter issues with SElinux. Try disabling selinux with `setenforce 0` and check if resolves the issue. If using the latest docker version and/or disabling SElinux does not fix the issue then please file a issue request on the [issues](https://github.com/eclipse/che/issues) page.

## Quick Start

```shell
# Interactive help. This command will fail by default but the CLI will print a prompt on how to proceed
docker run -it eclipse/che start

# Or, full start syntax where <path> is a local directory
docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock -v <path>:/data eclipse/che start

# Example output

$ docker run -ti -v /var/run/docker.sock:/var/run/docker.sock -v ~/Documents/che-data1:/data eclipse/che start
WARN: Bound 'eclipse/che' to 'eclipse/che:5.20.1'
INFO: (che cli): 5.20.1 - using docker 17.10.0-ce / native
WARN: Newer version '5.21.0' available
INFO: (che config): Generating che configuration...
INFO: (che config): Customizing docker-compose for running in a container
INFO: (che start): Preflight checks
         mem (1.5 GiB):           [OK]
         disk (100 MB):           [OK]
         port 8080 (http):        [AVAILABLE]
         conn (browser => ws):    [OK]
         conn (server => ws):     [OK]

INFO: (che start): Starting containers...
INFO: (che start): Services booting...
INFO: (che start): Server logs at "docker logs -f che"
INFO: (che start): Booted and reachable
INFO: (che start): Ver: 5.20.1
INFO: (che start): Use: http://172.19.20.180:8080
INFO: (che start): API: http://172.19.20.180:8080/swagger
````

The Che CLI - a Docker image - manages the other Docker images and supporting utilities that Che uses during its configuration or operations phases. Che installation with the CLI is a recommended installation method, however it is possible to run `che-server` image directly. See: [Run Che-Server directly][docker-native].


## Versions

Each version of Che is available as a Docker image tagged with a label that matches the version, such as `eclipse/che:6.0.0`. You can see all versions available by running `docker run eclipse/che version` or by [browsing DockerHub](https://hub.docker.com/r/eclipse/che/tags/).

We maintain "redirection" labels which reference special versions of Che:

| Variable | Description |
|----------|-------------|
| `latest` | The most recent stable release. |
| `6.0.0-latest` | The most recent stable release on the 6.x branch. |
| `nightly` | The nightly build. |

The software referenced by these labels can change over time. Since Docker will cache images locally, the `eclipse/che:<version>` image that you are running locally may not be current with the one cached on DockerHub. Additionally, the `eclipse/che:<version>` image that you are running references a manifest of Docker images that Che depends upon, which can also change if you are using these special redirection tags.

In the case of 'latest' images, when you initialize an installation using the CLI, we encode a `/instance/che.ver` file with the numbered version that latest references. If you begin using a CLI version that mismatches what was installed, you will be presented with an error.

To avoid issues that can appear from using 'nightly' or 'latest' redirections, you may:

1. Verify that you have the most recent version with `docker pull eclipse/che:<version>`.
2. When running the CLI, commands that use other Docker images have an optional `--pull` and `--force` command line option [which will instruct the CLI to check DockerHub](https://hub.docker.com/r/eclipse/che/) for a newer version and pull it down. Using these flags will slow down performance, but ensures that your local cache is current.

If you are running Che using a tagged version that is a not a redirection label, such as `6.0.0`, then these caching issues will not happen, as the software installed is tagged and specific to that particular version, never changing over time.

## Volume Mounts

We use volume mounts to configure certain parts of Che. The presence or absence of certain volume mounts will trigger certain behaviors in the system. For example, you can volume mount a Che source git repository with `:/repo` to use Che source code instead of the binaries and configuration that is shipped with our Docker images.

At a minimum, you must volume mount a local path to `:/data`, which will be the location that Che installs its configuration, user data, version and log information. Che also leaves behind a `cli.log` file in this location to debug any odd behaviors while running the system. In this folder we also create a `che.env` file which contains all of the admin configuration that you can set or override in a single location.

You can also use volume mounts to override the location of where your user or backup data is stored. By default, these folders will be created as sub-folders of the location that you mount to `:/data`. However, if you do not want your `/instance`, and `/backup` folder to be children, you can set them individually with separate overrides.

```
docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock
                    -v <local-path>:/data
                    -v <a-different-path>:/data/instance
                    -v <another-path>:/data/backup
                       eclipse/che:<version> [COMMAND]    
```

| Local Location   | Container Location   | Usage   
| --- | --- | ---
| `/var/run/docker.sock`   | `/var/run/docker.sock`   | This is how Che gets access to Docker daemon. This instructs the container to use your local Docker daemon when Che wants to create its own containers.   
| `/<your-path>/lib`   | `/data/lib`   | Inside the container, we make a copy of important libraries that your workspaces will need and place them into `/lib`. When Che creates a workspace container, that container will be using your local Docker daemon and the Che workspace will look for these libraries in your local `/lib`. This is a tactic we use to get files from inside the container out onto your local host.   
| `/<your-path>/workspaces`   | `/data/workspaces`   | The location of your workspace and project files.   
| `/<your-path>/storage`   | `/data/storage`   | The location where Che stores the meta information that describes the various workspaces, projects and user preferences.  


## Hosting

If you are hosting Che at a cloud service like DigitalOcean, AWS or Scaleways `CHE_HOST` must be set to the server public IP address or its DNS.

We will attempt to auto-set `CHE_HOST` by running an internal utility `docker run --net=host eclipse/che-ip:nightly`. This approach is not fool-proof. This utility is usually accurate on desktops, but usually fails on hosted servers. You can explicitly set this value to the IP address of your server:

```
docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock
                    -v <local-path>:/data
                    -e CHE_HOST=<your-ip-or-host>
                       eclipse/che:<version> [COMMAND]
```

## Run on Different Port

Either set `CHE_PORT=$your_port` in [che.env](docker-config.html#saving-configuration-in-version-control) or pass it as env in your docker run syntax: `-e CHE_PORT=$your_port`.

## Run As User

On Linux or Mac, you can run Eclipse Che container with a different user identity. The default is to run the Che container as root. You can  pass `--user uid:gid` or `-e CHE_USER=uid:gid` as a `docker run` parameter before the `eclipse/che` Docker image. The CLI will start the `eclipse/che-server` image with the same `uid:gid` combination along with mounting `/etc/group` and `etc/passwd`. When Che is run as a custom user, all files written from within the Che server to the host (such as `che.env` or `cli.log` will be written to disk with the custom user as the owner of the files. This feature is not available on Windows.


## Offline Installation

We support offline (disconnected from the Internet) installation and operation. This is helpful for restricted environments, regulated datacenters, or offshore installations. The offline installation downloads the CLI, core system images, and any stack images while you are within a network DMZ with DockerHub access. You can then move those files to a secure environment and start Che.

### 1. Save Che Images
While connected to the Internet, download Che Docker images:

```shell
docker run <docker-goodness> eclipse/che:<version> offline
```

The CLI will download images and save them to `/backup/*.tar` with each image saved as its own file. You can save these files to a different location by volume mounting a local folder to `:/data/backup`. The version tag of the CLI Docker image will be used to determine which versions of dependent images to download. There is about 1GB of data that will be saved.

The default execution will download none of the optional stack images, which are needed to launch workspaces of a particular type. There are a few dozen stacks for different programming languages and some of them are over 1GB in size. It is unlikely that your users will need all of the stacks, so you do not need to download all of them. You can get a list of available stack images by running `eclipse/che offline --list`. You can download a specific stack by running `eclipse/che offline --image:<image-name>` and the `--image` flag can be repeatedly used on a single command line.

### 2. Start Che In Offline Mode
Place the TAR files into a folder in the offline computer. If the files are in placed in a folder named `/tmp/offline`, you can run Che in offline mode with:

```shell
# Load the CLI
docker load < /tmp/offline/eclipse_che:<version>.tar

# Start Che in offline mode
docker run <other-properties> -v /tmp/offline:/data/backup eclipse/che:<version> start --offline
```

The `--offline` parameter instructs the Che CLI to load all of the TAR files located in the folder mounted to `/data/backup`. These images will then be used instead of routing out to the Internet to check for DockerHub. The preboot sequence takes place before any CLI functions make use of Docker. The `eclipse/che start`, `eclipse/che download`, and `eclipse/che init` commands support `--offline` mode which triggers this preboot sequence.


## Configuration

Che CLI allows a wide range of config changes to setup port, hostname, oAuth, Docker, git, and solve networking issues. See: [Che configuration on Docker][docker-config].

{% include links.html %}

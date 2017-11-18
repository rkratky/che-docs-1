---
title: "Getting started with Eclipse Che"
keywords: k8s, kubernetes
tags: [getting_started]
sidebar: mydoc_sidebar
permalink: index.html
<!-- toc: false -->
summary: Eclipse Che is a developer workspace server and cloud IDE. You install, run, and manage Eclipse Che with Docker.

---

## Download
This is the administration guide for the on-premises installation of Eclipse Che. This document discusses the installation, configuration, and operation of Che that you host on your own hardware or IaaS provider.

You can get a hosted version of Eclipse Che with Codenvy at [codenvy.io](http://codenvy.io).

## How to Get Help

### Support
If you are having a problem starting Che or workspaces, there are two diagnostic utilities that can help: `docker run eclipse/che info` on the command-line for diagnosing boot-time issues and a "diagnostic" page that you can launch from the lower corner of the dashboard that loads when Che first opens in your browser.

Post questions or issues [on GitHub](https://github.com/eclipse/che/issues). Please follow the [guidelines on issue reporting](https://github.com/eclipse/che/blob/master/CONTRIBUTING.md) and provide:

- output of `docker run eclipse/che info` command
- if requested, a support package with `docker run eclipse/che info --bundle`

### Documentation
We put a lot of effort into our docs. Please add suggestions on areas for improvement with a new [pull request](https://github.com/codenvy/che-docs/pulls) or [issue](https://github.com/codenvy/che-docs/issues).

## Quick Start
On any computer with Docker 1.11+ installed (Docker 1.12.5+ is recommended):

```shell
# Interactive help
docker run -it eclipse/che start

# Or, full start syntax where <path> is a local directory
docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock -v <path>:/data eclipse/che start
```

## Operate Che

```shell
# Start Eclipse Che with user data saved on Windows in c:\tmp
docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock -v /c/tmp:/data eclipse/che start
INFO: (che cli): Loading cli...
INFO: (che cli): Checking registry for version 'nightly' images
INFO: (che config): Generating che configuration...
INFO: (che config): Customizing docker-compose for running in a container
INFO: (che start): Preflight checks
         port 8080 (http):       [AVAILABLE]

INFO: (che start): Starting containers...
INFO: (che start): Services booting...
INFO: (che start): Server logs at "docker logs -f che"
INFO: (che start): Booted and reachable
INFO: (che start): Ver: nightly
INFO: (che start): Use: http://<your-ip>:8080
INFO: (che start): API: http://<your-ip>:8080/swagger

# Stop Che
docker run <DOCKER_OPTIONS> eclipse/che stop

# Restart Che
docker run <DOCKER_OPTIONS> eclipse/che restart

# Run a specific version of Che
docker run <DOCKER_OPTIONS> eclipse/che:<version> start

# Get help
docker run eclipse/che

# If boot2docker on Windows, mount a subdir of `%userprofile%` to `:/data`. For example:
docker run <DOCKER_OPTIONS> -v /c/Users/tyler/che:/data eclipse/che start

# If Che will be accessed from other machines add your server's external IP
docker run <DOCKER_OPTIONS> -e CHE_HOST=<your-ip> eclipse/che start
````


## Develop with Che  
Now that Che is running there are a lot of fun things to try:

- Become familiar with Che through [one of our tutorials]({{ base }}{{site.links["tutorials-multi-machine"]}}).
- [Import a project]({{ base }}{{site.links["ide-import-a-project"]}}) and setup [git authentication]({{ base }}{{site.links["ide-git-svn"]}}).
- Use [commands]({{ base }}{{site.links["ide-projects"]}}) to build and run a project.
- Create a [preview URL]({{ base }}{{site.links["ide-previews"]}}) to share your app.
- Setup a [debugger]( {{ base }}{{site.links["ide-debug"]}}).
- Create reproducible workspaces with [chedir]({{ base }}{{site.links["chedir-getting-started"]}}).
- Create a [custom runtime stack]({{ base }}{{site.links["devops-runtime-stacks"]}}).

## Pre-Reqs  

### Hardware

* 1 cores
* 256MB RAM
* 300MB disk space

Che requires 300 MB storage and 256MB RAM for internal services. The RAM, CPU and storage resources required for your users workspaces are additive. Che Docker images consume ~300MB of disk and the Docker images for your workspace templates can each range from 5MB up to 1.5GB. Che and its dependent core containers will consume about 500MB of RAM, and your running workspaces will each require at least 250MB RAM, depending upon user requirements and complexity of the workspace code and intellisense.

Boot2Docker, docker-machine, Docker for Windows, and Docker for Mac are all Docker variations that launch VMs with Docker running in the VM with access to Docker from your host. We recommend increasing your default VM size to at least 4GB. Each of these technologies have different ways to allow host folder mounting into the VM. Please enable this for your OS so that Che data is persisted on your host disk.

### Software

* Docker 1.12.5+ recommended, Docker 1.11+ minimum

The Che CLI - a Docker image - manages the other Docker images and supporting utilities that Che uses during its configuration or operations phases. The CLI also provides utilities for downloading an offline bundle to run Che while disconnected from the network.

Given the nature of the development and release cycle it is important that you have the latest version of Docker installed because any issue that you encounter might have already been fixed with a newer Docker release.

Install the most recent version of the Docker Engine for your platform using the [official Docker releases](http://docs.docker.com/engine/installation/), including support for Mac and Windows!  If you are on Linux, you can also install using:

```bash
wget -qO- https://get.docker.com/ | sh
```

Verify that Docker is installed with:

```shell  
# Should print "Hello from Docker!"
docker run hello-world
```

Sometimes Fedora and RHEL/CentOS users will encounter issues with SElinux. Try disabling selinux with `setenforce 0` and check if resolves the issue. If using the latest docker version and/or disabling selinux does not fix the issue then please file a issue request on the [issues](https://github.com/eclipse/che/issues) page.

## Known Issues
You can search Che's GitHub issues for items labeled `kind/bug` to see known issues.

There are two known issues where features work on Docker 1.13+, but do not on Docker 1.12:
1. SELinux: https://github.com/eclipse/che/issues/4747
2. `CHE_DOCKER_ALWAYS__PULL__IMAGE`: https://github.com/eclipse/che/issues/5503

#### Internal/External Ports
The default port required to run Che is `8080`. Che performs a preflight check when it boots to verify that the port is available. You can pass `-e CHE_PORT=<port>` in Docker portion of the start command to change the port that Che starts on.

Internal ports are ports within a local network. This is the most common senerio for most users when Che is installed on their local desktop/laptop. External ports are ports outside a local network. An example senerio of this would be a remote Che server on a cloud host provider. With either case ports need to be open and not blocked by firewalls or other applications already using the same ports.

All ports are TCP unless otherwise noted.

|Port >>>>>>>>>>>>>>>>|Service >>>>>>>>>>>>>>>>|Notes|
|---|---|---|
|5000|KeyCloak Port|
|8080|Tomcat Port|
|8000|Server Debug Port|Users developing Che extensions and custom assemblies would use this debug port to connect a remote debugger to che server.
|32768-65535|Docker and Che Agents|Users who launch servers in their workspace bind to ephemeral ports in this range. This range can be limited.

### Internet Connection
You can install Che while connected to a network or offline, disconnected from the Internet. If you perform an offline intallation, you need to first download a Che assembly while in a DMZ with a network connection to DockerHub.

### Networking
Che is a platform that launches workspaces using Docker on different networks. Your browser or desktop IDE then connects to these workspaces. This makes Che a Platform as a Service (PaaS) running on a distributed network. There are essential connections we establish:

1. Browser --> Che Server
2. Che Server --> Docker Daemon
3. Che Server --> Workspace
4. Workspace --> Che Server
5. Browser --> Workspace

Che goes through a progression algorithm to establish the protocol, IP address and port to establish a connection for each connection point. If you have launched Che and workspaces do not immediately start, the most common causes are:

1. Failed Che -> Workspace (set CHE_DOCKER_IP in `che.env`)
2. Failed Browser -> Workspace (set CHE_DOCKER_IP_EXTERNAL in `che.env`)
3. Firewall (required ports are not open)

When you first install Che, we will add a `che.env` file into the folder you mounted to `:/data`, and you can configure many variables to establish proper communications. After changing this file, restart Che for the changes to take affect.

```
Browser --> Che Server
   1. Default is 'http://localhost:${SERVER_PORT}/wsmaster/api'.
   2. Else use the value of CHE_API

Che Server --> Docker Daemon Progression:
   1. Use the value of CHE_DOCKER_DAEMON__URL
   2. Else, use the value of DOCKER_HOST system variable
   3. Else, use Unix socket over unix:///var/run/docker.sock

Che Server --> Workspace Connection:
   - If CHE_DOCKER_SERVER__EVALUATION__STRATEGY is 'default':
       1. Use the value of CHE_DOCKER_IP
       2. Else, if server connects over Unix socket, then use localhost
       3. Else, use DOCKER_HOST
   - If CHE_DOCKER_SERVER__EVALUATION__STRATEGY is 'docker-local':
       1. Use the address of the workspace container within the docker network
          and exposed ports
       2. If address is missing, if server connects over Unix socket, then use
          localhost and exposed ports
       3. Else, use DOCKER_HOST and published ports

Browser --> Workspace Connection:
   - If CHE_DOCKER_SERVER__EVALUATION__STRATEGY is 'default':
       1. If set use the value of CHE_DOCKER_IP_EXTERNAL
       2. Else if set use the value of CHE_DOCKER_IP
       3. Else, if server connects over Unix socket, then use localhost
       4. Else, use DOCKER_HOST
   - If CHE_DOCKER_SERVER__EVALUATION__STRATEGY is 'docker-local':
       1. If set use the value of CHE_DOCKER_IP_EXTERNAL
       2. Else use the address of the workspace container within the docker network,
          if it is set
       3. If address is missing, if server connects over Unix socket, then use
          localhost
       4. Else, use DOCKER_HOST

Workspace Agent --> Che Server
   1. Default is 'http://che-host:${SERVER_PORT}/wsmaster/api', where 'che-host'
      is IP of server.
   2. Else, use value of CHE_WORKSPACE_CHE__SERVER__ENDPOINT
   3. Else, if 'docker0' interface is unreachable, then 'che-host' replaced with
      172.17.42.1 or 192.168.99.1
   4. Else, print connection exception
```

If you suspect that blocked ports, firewall, Che's network configuration, or websockets are preventing Che from working properly, we provide a browser diagnostic in the lower right corner that runs tests between the browser and the Che server and a generated workspace.

## Versions
Each version of Che is available as a Docker image tagged with a label that matches the version, such as `eclipse/che:5.0.0-M7`. You can see all versions available by running `docker run eclipse/che version` or by [browsing DockerHub](https://hub.docker.com/r/eclipse/che/tags/).

We maintain "redirection" labels which reference special versions of Che:

| Variable | Description |
|----------|-------------|
| `latest` | The most recent stable release. |
| `5.0.0-latest` | The most recent stable release on the 5.x branch. |
| `nightly` | The nightly build. |

The software referenced by these labels can change over time. Since Docker will cache images locally, the `eclipse/che:<version>` image that you are running locally may not be current with the one cached on DockerHub. Additionally, the `eclipse/che:<version>` image that you are running references a manifest of Docker images that Che depends upon, which can also change if you are using these special redirection tags.

In the case of 'latest' images, when you initialize an installation using the CLI, we encode a `/instance/che.ver` file with the numbered version that latest references. If you begin using a CLI version that mismatches what was installed, you will be presented with an error.

To avoid issues that can appear from using 'nightly' or 'latest' redirections, you may:

1. Verify that you have the most recent version with `docker pull eclipse/che:<version>`.
2. When running the CLI, commands that use other Docker images have an optional `--pull` and `--force` command line option [which will instruct the CLI to check DockerHub](https://hub.docker.com/r/eclipse/che/) for a newer version and pull it down. Using these flags will slow down performance, but ensures that your local cache is current.

If you are running Che using a tagged version that is a not a redirection label, such as `5.0.0-M7`, then these caching issues will not happen, as the software installed is tagged and specific to that particular version, never changing over time.

# Volume Mounts
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

## Hosting

If you are hosting Che at a cloud service like DigitalOcean, AWS or Scaleways `CHE_HOST` must be set to the server IP address or its DNS.

We will attempt to auto-set `CHE_HOST` by running an internal utility `docker run --net=host eclipse/che-ip:nightly`. This approach is not fool-proof. This utility is usually accurate on desktops, but usually fails on hosted servers. You can explicitly set this value to the IP address of your server:

```bash
docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock
                    -v <local-path>:/data
                    -e CHE_HOST=<your-ip-or-host>
                       eclipse/che:<version> [COMMAND]
````

### Run As User

On Linux or Mac, you can run Eclipse Che's container with a different user identity. The default is to run the Che container as root. You can  pass `--user uid:gid` or `-e CHE_USER=uid:gid` as a `docker run` parameter before the `eclipse/che` Docker image. The CLI will start the `eclipse/che-server` image with the same `uid:gid` combination along with mounting `/etc/group` and `etc/passwd`. When Che is run as a custom user, all files written from within the Che server to the host (such as `che.env` or `cli.log` will be written to disk with the custom user as the owner of the files. This feature is not available on Windows.

# Multiple Containers
If you want to run multiple Che instances at the same time on the same host, each execution of Che needs to have a different:
1. Port
2. Che container name
3. Data folder

We determine the Che container name with the format `<prefix>-<port>`. The default prefix is `che` and can be changed on the CLI with `-e CHE_CONTAINER_PREFIX=<name>`. If you use the default port, then this value is not added to the container name. However, if you change the port with `-e CHE_PORT=<port>` then we will use that value as part of the container name.

When the CLI executes, it creates a configuration that ultimately launches a container from `eclipse/che-server` image which is the image that contains the Che container. This container receives the unique name created above.

You can also optionally just set the name of the container with a UUID by setting `-e CHE_CONTAINER=<name>`.

# Proxy Installation
You can install and operate Che behind a proxy:

1. Configure each physical node's Docker daemon with proxy access.
2. Optionally, override workspace proxy settings for users if you want to restrict their Internet access.

Before starting Che, configure [Docker's daemon for proxy access](https://docs.docker.com/engine/admin/systemd/#/http-proxy). If you have Docker for Windows or Docker for Mac installed on your desktop and installing Che, these utilities have a GUI in their settings which let you set the proxy settings directly.

Please be mindful that your `HTTP_PROXY` and/or `HTTPS_PROXY` that you set in the Docker daemon must have a protocol and port number. Proxy configuration is quite finnicky, so please be mindful of providing a fully qualified proxy location.

If you configure `HTTP_PROXY` or `HTTPS_PROXY` in your Docker daemon, we will add `localhost,127.0.0.1,CHE_HOST` to your `NO_PROXY` value where `CHE_HOST` is the DNS or IP address. We recommend that you add the short and long form DNS entry to your Docker's `NO_PROXY` setting if it is not already set.

We will add some values to `che.env` that contain some proxy overrides. You can optionally modify these with overrides:

```
CHE_HTTP_PROXY=<YOUR_PROXY_FROM_DOCKER>
CHE_HTTPS_PROXY=<YOUR_PROXY_FROM_DOCKER>
CHE_NO_PROXY=localhost,127.0.0.1,<YOUR_CHE_HOST>
CHE_HTTP_PROXY_FOR_WORKSPACES=<YOUR_PROXY_FROM_DOCKER>
CHE_HTTPS_PROXY_FOR_WORKSPACES=<YOUR_PROXY_FROM_DOCKER>
CHE_NO_PROXY_FOR_WORKSPACES=localhost,127.0.0.1,<YOUR_CHE_HOST>
```

The last three entries are injected into workspaces created by your users. This gives your users access to the Internet from within their workspaces. You can comment out these entries to disable access. However, if that access is turned off, then the default templates with source code will fail to be created in workspaces as those projects are cloned from GitHub.com. Your workspaces are still functional, we just prevent the template cloning.

## Offline Installation
We support offline (disconnected from the Internet) installation and operation. This is helpful for restricted environments, regulated datacenters, or offshore installations. The offline installation downloads the CLI, core system images, and any stack images while you are within a network DMZ with DockerHub access. You can then move those files to a secure environment and start Che.

### Save Che Images
While connected to the Internet, download Che's Docker images:

```shell
docker run <docker-goodness> eclipse/che:<version> offline
```

The CLI will download images and save them to `/backup/*.tar` with each image saved as its own file. You can save these files to a differnet location by volume mounting a local folder to `:/data/backup`. The version tag of the CLI Docker image will be used to determine which versions of dependent images to download. There is about 1GB of data that will be saved.

The default execution will download none of the optional stack images, which are needed to launch workspaces of a particular type. There are a few dozen stacks for different programming languages and some of them are over 1GB in size. It is unlikely that your users will need all of the stacks, so you do not need to download all of them. You can get a list of available stack images by running `eclipse/che offline --list`. You can download a specific stack by running `eclipse/che offline --image:<image-name>` and the `--image` flag can be repeatedly used on a single command line.

### Start Che In Offline Mode
Place the TAR files into a folder in the offline computer. If the files are in placed in a folder named `/tmp/offline`, you can run Che in offline mode with:

```shell
# Load the CLI
docker load < /tmp/offline/eclipse_che:<version>.tar

# Start Che in offline mode
docker run <other-properties> -v /tmp/offline:/data/backup eclipse/che:<version> start --offline
```

The `--offline` parameter instructs the Che CLI to load all of the TAR files located in the folder mounted to `/data/backup`. These images will then be used instead of routing out to the Internet to check for DockerHub. The preboot sequence takes place before any CLI functions make use of Docker. The `eclipse/che start`, `eclipse/che download`, and `eclipse/che init` commands support `--offline` mode which triggers this preboot sequence.

## Uninstall

```shell
### Remove your Che configuration and destroy user projects and database
docker run eclipse/che:<version> destroy [--quiet|--cli]

### Deletes Che's images from your Docker registry
docker run eclipse/che:<version> rmi

### Delete the Che CLI
docker rmi -f eclipse/che
```

### Licensing
Che is licensed with the Eclipse Public License.

### Configuration
Change Che's port, hostname, oAuth, Docker, git, and networking by setting [Eclipse Che properties]({{ base }}/docs/setup/configuration/index.html).

{% include links.html %}

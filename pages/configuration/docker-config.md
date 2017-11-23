---
title: "Configuration&#58 Docker"
keywords: docker, configuration
tags: [installation, docker]
sidebar: user_sidebar
permalink: docker-config.html
folder: configuration
---

{% include links.html %}


## Docker Unix Socket Mounting vs TCP Mode  
The `-v /var/run/docker.sock:/var/run/docker.sock` syntax is for mounting a Unix socket so that when a process inside the container speaks to a Docker daemon, the process is redirected to the same socket on the host system.

However, peculiarities of file systems and permissions may make it impossible to invoke Docker processes from inside a container. If this happens, the Che startup scripts will print an error about not being able to reach the Docker daemon with guidance on how to resolve the issue.

An alternative solution is to run Docker daemon in TCP mode on the host and export `DOCKER_HOST` environment variable in the container.  You can tell the Docker daemon to listen on both Unix sockets and TCP.  On the host running the Docker daemon:

```text  
# Set this environment variable and restart the Docker daemon
DOCKER_OPTS=" -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock"

# Verify that the Docker API is responding at:
http://localhost:2375/containers/json
```

Having verified that your Docker daemon is listening, run the Che container with the with `DOCKER_HOST` environment variable set to the IP address of `docker0` or `eth0` network interface. If `docker0` is running on 1.1.1.1 then:

```shell  
docker run -ti -e DOCKER_HOST=tcp://1.1.1.1:2375 -v /var/run/docker.sock:/var/run/docker.sock -v ~/Documents/che-data1:/data eclipse/che start
```

Alternatively, you can save this env in `che.env` and restart Che.

## Proxy Installation

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

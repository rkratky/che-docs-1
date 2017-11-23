---
title: "Docker vs OpenShift Deployment"
keywords: docker, oepsnhift
tags: [installation, docker, openshift]
sidebar: user_sidebar
permalink: docker_openshift.html
folder: setup
---

## Running Che on Docker

Che on Docker isn't scalable, i.e. one cannot add more nodes to run workspaces. Of course, it is possible to use a fairly large instance with 8+ CPUs and 32+ RAM, however at some point a great number of running containers (with heavy processes running in them) can make the node unresponsive. This will both affect workspace master and all running workspaces. At the same time, Che on Docker is flexible and easily configurable for an ordinary user:

### Root Access

With Che on Docker, users can have root access in workspace containers. This means you can run system services and install software in runtime.

### SSH Access

By default, `sshd` starts in all ready-to-go stack images. You can connect to a remote workspace using ssh keys or username/password (available in custom stacks only) or sync workspace project files to a local machine.

Though deploying administering Che on Docker may seem a little bit easier than doing it in OpenShift, it's OpenShift that unleashes the power of Eclipse Che as a workspace server and cloud IDE.

**[Install on Docker][docker]**

## Deploying to OpenShift

When deployed to OpenShift, Che provides the following features that are not available in Che on Docker:

### Scalability

Che talks to OpenShift API to create workspace pods, and it is OpenShift that schedules them to available nodes. OpenShift cluster admin can add and remove nodes (or label them as those that are not ready to run pods) depending on demand for running Che workspaces.

### HTTPS support

HAProxy that runs in an OpenShift cluster takes care of creating secure routes, thus HTTPS support is provided by OpenShift itself.

### Health Checks

OpenShift restarts failed deployments and offers health checks for pods. This can significantly minimize the effect of infrastructure outages.

At the same time there are some OpenShift security restrictions which are [root access](#root-access) and [ssh access](#ssh-access). See [Configuration][openshift-config].

**[Deploy to OpenShift][openshift]**

{% include links.html %}

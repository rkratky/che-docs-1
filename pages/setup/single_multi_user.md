---
title: "Single and Multi-User Che"
keywords: single-user, Eclipse Che
tags: [installation, getting_started]
sidebar: user_sidebar
permalink: single_multi_user.html
folder: setup
toc: false

---

Che is shipped as two different assemblies - single and multi user. A single user Che **has no components that provide multi tenancy and permissions**. Thus, Che server and workspaces are not secured. This makes a single user Che a good choice for developers working locally.

A multi user Che provides multi-tenancy i.e. **users accounts and workspaces are isolated and secured** with KeyCloak tokens. Che uses [KeyCloak](http://www.keycloak.org/) as a mechanism to register, manage and authenticate users. Permissions API regulates access to different entities in Che, such as workspaces, stacks, recipes, organizations etc. User information is stored in a persistent DB that supports migrations (PostgreSQL).

## What Flavor to Choose?

If you plan using Che just on your local machine or just evaluate the platform, it is reasonable to start with a **single-user Che**.

**Single User Che Pros:**

* The CLI will pull fewer Images
* You will faster get to User Dashboard (no login)

**Multi-User Che Pros**

* A Fully functional web IDE with fine grained access controls
* A standalone Keycloak server that supports users federation and identity providers

By default **Che gets deployed as a single user** assembly both on Docker and OpenShift. Special flags must be provided to enable multi-user functionality.

Proceed to installation:

* Run on [Docker][docker]
* Deploy to [OpenShift][openshift]

{% include links.html %}

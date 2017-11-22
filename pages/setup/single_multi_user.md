---
title: "Single and Multi-User Che"
keywords: single-user, Eclipse Che
tags: [installation]
sidebar: user_sidebar
permalink: single_multi_user.html
folder: setup
---

Che is shipped as two different assemblies - single and multi user. A single user Che does not have any components that provide multi tenancy and permissions. Thus, Che server and workspaces are not secured. This makes a single user Che a good choice for developers working locally.

A [multi user Che][docker] provides multi-tenancy i.e. users accounts and workspaces are isolated and secured with KeyCloak tokens. Che uses [KeyCloak](http://www.keycloak.org/) as a mechanism to register, manage and authenticate users. Permissions API regulates access to different entities in Che, such as workspaces, stacks, recipes, organizations etc. User information is stored in a persistent DB that supports migrations (PostgreSQL).

[test][single_multi_user]
{% include links.html %}

# Services

## Table of Contents (ToC)
<!--ts-->
   * [Services](#services)
        * [Nginx dummy](#nginx-dummy)
        * [6G Latency Sensitive Service](#6g-latency-sensitive-service)
<!--te-->

## Nginx dummy

It is a nginx app that will create 4 different replicas of the same pod into 4 different nodes

## 6G Latency Sensitive Service

Deploy the following secret in the default namespace:

````bash
kubectl create secret docker-registry regcred --docker-username=<your-public-gitlab-user> --docker-password=<your-public-gitlab-password> --docker-server=registry.gitlab.com/netmode
````

For more information visit the following GitLab repository [6g-latency-sensitive-service](https://gitlab.com/netmode/6g-latency-sensitive-service)
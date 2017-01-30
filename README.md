# JENKINS_K8S_SLAVE
A docker container that can be used as a jenkins slave that can run gcloud commands.


## Setup jenkins

Go to Manage Jenkins > Manage Nodes > New Node, create a permanent agent, set
the	value "/var/jenkins" as the "Remote root directory", set the value
"Launch agent via Java Web Start" as the "Launch method" and click save.

## Building

```
docker build -t jenkins_k8s_slave .

```

## Running

```
docker run -it --rm /
	-v "//c/Users/gcloud-service-account.json:/auth.json" /
	-e "GCLOUD_ACCOUNT_FILE=/auth.json" /
	-e "GCLOUD_ACCOUNT_EMAIL=<service account email>" /
	-e "GCLOUD_PROJECT=<project name>" /
	-e "GCLOUD_ZONE=<config zone>" /
	-v /var/run/docker.sock:/var/run/docker.sock /
	-e "JENKINS_URL=<jenkins url>" /
	-e "JENKINS_SECRET=<jenkins slave secret>" /
	-e "JENKINS_SLAVE=<jenkins slave name>" /
	jenkins_k8s_slave

```

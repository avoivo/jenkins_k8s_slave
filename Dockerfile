FROM ubuntu:16.04

MAINTAINER Athanasios Voivodas <tvoivodas@gmail.com>

# Install tools
RUN apt-get update && \
  apt-get install -y wget unzip python \
  && apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Install the Google Cloud SDK.

ENV PATH /opt/google-cloud-sdk/bin:$PATH
RUN mkdir -p /opt/gcloud && \
    wget --no-check-certificate --directory-prefix=/tmp/ https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.zip && \
    unzip /tmp/google-cloud-sdk.zip -d /opt/ && \
    /opt/google-cloud-sdk/install.sh --usage-reporting=true --path-update=true --bash-completion=true --rc-path=/opt/gcloud/.bashrc --disable-installation-options && \
    gcloud --quiet components update alpha beta kubectl core gsutil gcloud && \
    rm -rf /tmp/*

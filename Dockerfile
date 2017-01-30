FROM ubuntu:16.04

MAINTAINER Athanasios Voivodas <tvoivodas@gmail.com>


# Install tools
RUN apt-get update && \
  apt-get install -y wget unzip python curl default-jre \
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




# docker slave

ENV HOME /home/jenkins
RUN groupadd -g 10000 jenkins
# RUN groupadd -g docker jenkins
RUN useradd -c "Jenkins user" -d $HOME -u 10000 -g 10000 -m jenkins

ARG VERSION=2.62

RUN curl --create-dirs -sSLo /usr/share/jenkins/slave.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${VERSION}/remoting-${VERSION}.jar \
  && chmod 755 /usr/share/jenkins \
  && chmod 644 /usr/share/jenkins/slave.jar

# create workspace
RUN mkdir /var/jenkins

RUN chown -R jenkins /var/jenkins
RUN chgrp -R jenkins /var/jenkins



USER jenkins
RUN mkdir /home/jenkins/.jenkins
VOLUME /home/jenkins/.jenkins
WORKDIR /home/jenkins


# entrypoint
COPY entrypoint /usr/local/bin/entrypoint

VOLUME ["/.config"]
# CMD ["/bin/bash"]
ENTRYPOINT exec /usr/local/bin/entrypoint

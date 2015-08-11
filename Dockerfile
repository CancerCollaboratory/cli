FROM       ubuntu:14.04
MAINTAINER Bob Tiernay <btiernay@oicr.on.ca>

# Update and tools
RUN \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y curl wget software-properties-common

# Install Oracle JDK 8
RUN add-apt-repository ppa:webupd8team/java
RUN apt-get update && apt-get upgrade -y
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get install -y \
    oracle-java8-installer \
    oracle-java8-set-default \
    git
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# Install S3cmd for Log Aggregation
RUN apt-get install -y\
    python-pip
RUN pip install s3cmd

# Install applications
RUN mkdir -p /collab/metadata && \
    cd /collab/metadata && \
    wget -qO- https://seqwaremaven.oicr.on.ca/artifactory/dcc-release/org/icgc/dcc/dcc-metadata-client/[RELEASE]/dcc-metadata-client-[RELEASE]-dist.tar.gz | \
    tar xvz --strip-components 1
RUN mkdir -p /collab/storage && \
    cd /collab/storage && \
    wget -qO- https://seqwaremaven.oicr.on.ca/artifactory/collab-release/collaboratory/object-store-client/[RELEASE]/object-store-client-[RELEASE]-dist.tar.gz | \
    tar xvz --strip-components 1
RUN mkdir -p /collab/gitroot && cd /collab/gitroot && \
    git clone https://github.com/CancerCollaboratory/cli.git && \
    ln -s /collab/gitroot/cli/upload.sh /collab/upload.sh 
RUN mkdir -p /collab/upload

WORKDIR /collab

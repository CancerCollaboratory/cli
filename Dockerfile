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
    oracle-java8-set-default
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# Create the application directory
RUN mkdir -p /collab/metadata

# Install application
RUN cd /collab/metadata && \
    wget -qO- https://seqwaremaven.oicr.on.ca/artifactory/dcc-release/org/icgc/dcc/dcc-metadata-client/[RELEASE]/dcc-metadata-client-[RELEASE]-dist.tar.gz | \
    tar xvz --strip-components 1

CMD ["bash"]

FROM    ubuntu:14.04
MAINTAINER Bob Tiernay <btiernay@oicr.on.ca>

# Installing Oracle JDK
RUN apt-get update && apt-get install -y software-properties-common
RUN add-apt-repository ppa:webupd8team/java
RUN apt-get update && apt-get upgrade -y
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get install -y \
    oracle-java8-installer \
    oracle-java8-set-default
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# Install command-line utils
RUN apt-get install -y \
    vim.tiny \
    git \
    curl

# Create the MongoDB data directory
RUN mkdir /collab/

RUN cd /collab && wget -qO- https://goo.gl/WjJZlt | tar xvz

FROM       ubuntu:14.04
MAINTAINER Bob Tiernay <btiernay@oicr.on.ca>

# Update and tools
RUN DEBIAN_FRONTEND=noninteractive \
  apt-get update

RUN DEBIAN_FRONTEND=noninteractive \
  apt-get -y upgrade 

RUN DEBIAN_FRONTEND=noninteractive \
  apt-get install -y curl wget software-properties-common

# Install Oracle JDK 8
RUN wget -q https://seqwaremaven.oicr.on.ca/artifactory/simple/dcc-dependencies/jdk-8u45-linux-x64.tar.gz 
RUN tar -xvf jdk-8u45-linux-x64.tar.gz
RUN mkdir -p /usr/lib/jvm
RUN mv ./jdk1.8.0_45 /usr/lib/jvm/

RUN update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jdk1.8.0_45/bin/java" 1
RUN update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/jdk1.8.0_45/bin/javac" 1
RUN update-alternatives --install "/usr/bin/javaws" "javaws" "/usr/lib/jvm/jdk1.8.0_45/bin/javaws" 1

RUN chmod a+x /usr/bin/java
RUN chmod a+x /usr/bin/javac
RUN chmod a+x /usr/bin/javaws
RUN chown -R root:root /usr/lib/jvm/jdk1.8.0_45

# Install S3cmd for Log Aggregation
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    python-pip
RUN DEBIAN_FRONTEND=noninteractive pip install s3cmd
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y git

# Install applications
RUN mkdir -p /collab/metadata && \
    cd /collab/metadata && \
    wget -qO- https://seqwaremaven.oicr.on.ca/artifactory/dcc-release/org/icgc/dcc/dcc-metadata-client/0.0.12/dcc-metadata-client-0.0.12-dist.tar.gz | \
    tar xvz --strip-components 1
RUN mkdir -p /collab/storage && \
    cd /collab/storage && \
    wget -qO- https://seqwaremaven.oicr.on.ca/artifactory/simple/dcc-release/collaboratory/object-store-client/0.0.21/object-store-client-0.0.21-dist.tar.gz | \
    tar xvz --strip-components 1
RUN mkdir -p /collab/storage-ceph && \
    cd /collab/storage-ceph && \
    wget -qO- https://seqwaremaven.oicr.on.ca/artifactory/simple/dcc-snapshot/dcc-storage-client-ceph-0.0.26-SNAPSHOT-dist.tar.gz | \
    tar xvz --strip-components 1
RUN mkdir -p /collab/gitroot && cd /collab/gitroot && \
    git clone https://github.com/CancerCollaboratory/cli.git && \
    ln -s /collab/gitroot/cli/upload.sh /collab/upload.sh
RUN ln -s /collab/gitroot/cli/upload-ceph.sh /collab/upload-ceph.sh
RUN mkdir -p /collab/upload

WORKDIR /collab


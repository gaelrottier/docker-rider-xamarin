FROM openjdk:8-jdk

ENV LANG C.UTF-8 
ENV RIDER_VERSION .Rider2017.2 
ENV RIDER_VERSION_SHORT 2017.2

RUN sed 's/main$/main universe/' -i /etc/apt/sources.list && \
    apt-get update -qq && \
    echo 'Installing OS dependencies' && \
    apt-get install -qq -y --fix-missing \
        git \
        wget \
        sudo \
        && \
    echo 'Cleaning up' && \
    apt-get clean -qq -y && \
    apt-get autoclean -qq -y && \
    apt-get autoremove -qq -y &&  \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

RUN echo "Downloading Rider ${RIDER_VERSION_SHORT}" && \
    wget https://download.jetbrains.com/resharper/JetBrains.Rider-${RIDER_VERSION_SHORT}.tar.gz -O /tmp/rider.tar.gz -q && \
    echo 'Installing Rider' && \
    mkdir -p /opt/rider && \
    tar -xf /tmp/rider.tar.gz --strip-components=1 -C /opt/rider && \
    rm /tmp/rider.tar.gz

RUN echo 'Creating user: developer' && \
    mkdir -p /home/developer && \
    echo "developer:x:1000:1000:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:1000:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown developer:developer -R /home/developer

RUN mkdir -p /home/developer/${RIDER_VERSION}/config/options && \
    mkdir -p /home/developer/${RIDER_VERSION}/config/plugins && \
    chown developer:developer -R /home/developer/${RIDER_VERSION}

USER developer

ENV HOME /home/developer

WORKDIR /home/developer/dev

CMD /opt/rider/bin/rider.sh

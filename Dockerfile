FROM ubuntu:latest

RUN apt-get update

# Necesary for non interactive instalations...
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update

# Oracle Java
RUN apt-get install -y software-properties-common python-software-properties && add-apt-repository -y ppa:webupd8team/java && apt-get update
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get install -y oracle-java8-installer && apt-get install -y oracle-java8-set-default

# Install dependencies
RUN apt-get install -y curl \
  unzip \
  x11-apps \
  lib32z1 \
  lib32ncurses5 \
  lib32bz2-1.0 \
  lib32stdc++6 \
  git-core \
  vim \
  ant

# Download Android Studio + SDK
RUN curl 'https://dl.google.com/dl/android/studio/ide-zips/1.5.0.4/android-studio-ide-141.2422023-linux.zip' > /tmp/studio.zip && unzip -d /opt /tmp/studio.zip && rm /tmp/studio.zip

# Clean up
RUN apt-get clean
RUN apt-get purge

# Set up permissions for X11 access.
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    sudo chown ${uid}:${gid} -R /home/developer

USER developer
ENV HOME /home/developer
ENV PATH /opt/gtk/bin:$PATH
CMD /opt/android-studio/bin/studio.sh

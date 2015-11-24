FROM ubuntu:14.10

RUN apt-get update

# Download specific Android Studio bundle (all packages).
RUN apt-get install -y curl unzip
RUN curl 'https://dl.google.com/dl/android/studio/ide-zips/1.5.0.4/android-studio-ide-141.2422023-linux.zip' > /tmp/studio.zip && unzip -d /opt /tmp/studio.zip && rm /tmp/studio.zip

# Install X11
RUN apt-get install -y x11-apps

# Install prerequisites
RUN apt-get install -y openjdk-7-jdk lib32z1 lib32ncurses5 lib32bz2-1.0 lib32stdc++6

# Install other useful tools
RUN apt-get install -y git-core vim ant

# Clean up
RUN apt-get clean
RUN apt-get purge

# Set up permissions for X11 access.
RUN export uid=developer gid=developer && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer

USER developer
ENV HOME /home/developer
CMD /opt/android-studio/bin/studio.sh

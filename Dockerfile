FROM debian:latest
MAINTAINER leundeufranky [at] gmail [dot] com

ENV DEBIAN_FRONTEND=noninteractive \
    ANDROID_HOME=/opt/android-sdk-linux \
    NPM_VERSION=6.9.0 \
    IONIC_VERSION=4.12.0 \
    CORDOVA_VERSION=8.1.2 \
    YARN_VERSION=1.12.3 \
    GRADLE_VERSION=4.10.3 \
    # Fix for the issue with Selenium, as described here:
    # https://github.com/SeleniumHQ/docker-selenium/issues/87
    DBUS_SESSION_BUS_ADDRESS=/dev/null

# Install basics
RUN apt-get update &&  \
    apt-get install -y git wget curl unzip build-essential && \
    curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get update &&  \
    apt-get install -y nodejs && \
    npm install -g npm@"$NPM_VERSION" cordova@"$CORDOVA_VERSION" ionic@"$IONIC_VERSION" yarn@"$YARN_VERSION" && \
    npm cache clear --force && \
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    dpkg --unpack google-chrome-stable_current_amd64.deb && \
    apt-get install -f -y && \
    apt-get clean && \
    rm google-chrome-stable_current_amd64.deb && \
    mkdir Sources && \
    mkdir -p /root/.cache/yarn/ && \

# Font libraries
    apt-get -qqy install fonts-ipafont-gothic xfonts-100dpi xfonts-75dpi xfonts-cyrillic xfonts-scalable libfreetype6 libfontconfig && \

# install python-software-properties (so you can do add-apt-repository)
    apt-get update && apt-get install -y -q software-properties-common  && \
    apt-get install default-jre -y && \
    apt-get install default-jdk -y && \
    echo java -version && \ 

# System libs for android enviroment
    echo ANDROID_HOME="${ANDROID_HOME}" >> /etc/environment && \
    dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --force-yes expect ant wget libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1 qemu-kvm kmod && \
    apt-get clean && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \

# Install Android Tools
    mkdir  /opt/android-sdk-linux && cd /opt/android-sdk-linux && \
    wget --output-document=android-tools-sdk.zip --quiet https://dl.google.com/android/repository/tools_r25.2.3-linux.zip && \
    unzip -q android-tools-sdk.zip && \
    rm -f android-tools-sdk.zip && \

# Install Gradle
    mkdir  /opt/gradle && cd /opt/gradle && \
    wget --output-document=gradle.zip --quiet https://services.gradle.org/distributions/gradle-"$GRADLE_VERSION"-bin.zip && \
    unzip -q gradle.zip && \
    rm -f gradle.zip && \
    chown -R root. /opt

# Setup environment
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:/opt/gradle/gradle-${GRADLE_VERSION}/bin

# Install Android SDK
RUN yes Y | ${ANDROID_HOME}/tools/bin/sdkmanager --licenses
RUN ${ANDROID_HOME}/tools/bin/sdkmanager "platform-tools"

RUN yes Y | ${ANDROID_HOME}/tools/bin/sdkmanager "platforms;android-19" \
    "platforms;android-20" \
    "platforms;android-21" \
    "platforms;android-22" \
    "platforms;android-23" \
    "platforms;android-24" \
    "platforms;android-25" \
    "platforms;android-26" \
    "platforms;android-27" \
    "platforms;android-28" \
    "build-tools;19.1.0" \
    "build-tools;20.0.0" \
    "build-tools;21.1.2" \
    "build-tools;22.0.1" \
    "build-tools;23.0.3" \
    "build-tools;24.0.3" \
    "build-tools;25.0.3" \
    "build-tools;26.0.3" \
    "build-tools;27.0.1" \
    "build-tools;28.0.2" \
    "extras;android;m2repository" \
    "extras;google;m2repository" \
    "extras;google;google_play_services" \
    "add-ons;addon-google_apis-google-19" \
    "add-ons;addon-google_apis-google-21" \
    "add-ons;addon-google_apis-google-22" \
    "add-ons;addon-google_apis-google-23" \
    "add-ons;addon-google_apis-google-24"


RUN cordova telemetry off

WORKDIR Sources
EXPOSE 8100 35729
CMD ["ionic", "serve"]

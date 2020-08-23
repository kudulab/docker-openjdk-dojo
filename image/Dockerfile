FROM openjdk:14-jdk-buster

ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini

# Install common Dojo scripts
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  sudo git ca-certificates wget make && \
  git clone --depth 1 -b 0.9.0 https://github.com/kudulab/dojo.git /tmp/dojo_git &&\
  /tmp/dojo_git/image_scripts/src/install.sh && \
  rm -r /tmp/dojo_git

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends nano

ENV GRADLE_VERSION 6.5.1
ENV GRADLE_HOME /usr/lib/gradle/gradle-${GRADLE_VERSION}
RUN cd /tmp &&\
  wget https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip &&\
  unzip gradle-${GRADLE_VERSION}-bin.zip && mv gradle-${GRADLE_VERSION}/ /usr/lib/ &&\
  rm gradle-${GRADLE_VERSION}-bin.zip &&\
  ln -s /usr/lib/gradle-${GRADLE_VERSION}/bin/gradle /usr/bin/gradle

ENV MAVEN_VERSION 3.3.9
RUN cd /tmp/ &&\
  wget --quiet http://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.zip &&\
  unzip apache-maven-${MAVEN_VERSION}-bin.zip &&\
  mv apache-maven-${MAVEN_VERSION} /usr/lib/ &&\
  rm apache-maven-${MAVEN_VERSION}-bin.zip &&\
  ln -s /usr/lib/apache-maven-${MAVEN_VERSION}/bin/mvn /usr/bin/mvn

ADD https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein /usr/bin/lein
RUN chmod -c 0755 /usr/bin/lein

COPY etc_dojo.d/scripts/* /etc/dojo.d/scripts/
COPY etc_dojo.d/variables/* /etc/dojo.d/variables/

COPY profile /home/dojo/.profile
COPY bashrc /home/dojo/.bashrc
RUN chown dojo:dojo /home/dojo/.profile /home/dojo/.bashrc

RUN chmod +x /tini
ENTRYPOINT ["/tini", "-g", "--", "/usr/bin/entrypoint.sh"]
CMD ["/bin/bash"]

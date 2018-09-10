FROM openjdk:8u181

COPY apt_01proxy /etc/apt/apt.conf.d/01_proxy

ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini

# For ide:
# * entrypoint requires sudo and shadow
# * git is needed to install ide image configs
# * ca-certificated needed when running git clone to avoid this error:
# fatal: unable to access 'https://github.com/ai-traders/ide.git/': Problem with the SSL CA cert (path? access rights?)
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  sudo git ca-certificates wget && \
  git clone --depth 1 -b 0.9.0 https://github.com/ai-traders/ide.git /tmp/ide_git && \
  /tmp/ide_git/ide_image_scripts/src/install.sh && \
  rm -r /tmp/ide_git && \
  echo 'ide ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

COPY ./ca.crt /usr/local/share/ca-certificates/ait.crt
RUN update-ca-certificates

COPY etc_ide.d/scripts/* /etc/ide.d/scripts/
COPY etc_ide.d/variables/* /etc/ide.d/variables/

# we create here custom entrypoint
COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod 755 /usr/bin/entrypoint.sh

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends nano

ENV GRADLE_VERSION 4.10
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

RUN cd tmp &&\
  wget https://releases.hashicorp.com/vault/0.10.1/vault_0.10.1_linux_amd64.zip -O /tmp/vault.zip &&\
  unzip /tmp/vault.zip &&\
  cp /tmp/vault /usr/local/bin/vault &&\
  chmod +x /usr/local/bin/vault &&\
  rm -rf /tmp/vault*

ADD http://os2.ai-traders.com:6780/swift/v1/secret-ops/0.3.1/setup-kube /usr/bin/setup-kube
RUN chmod 0755 /usr/bin/setup-kube

RUN chmod +x /tini
ENTRYPOINT ["/tini", "-g", "--", "/usr/bin/entrypoint.sh"]
CMD ["/bin/bash"]

ARG this_image_tag_arg
ARG this_image_name_arg
ENV this_image_tag=${this_image_tag_arg} this_image_name=${this_image_name_arg}

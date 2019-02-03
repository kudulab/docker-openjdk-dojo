FROM openjdk:8u181

COPY apt_01proxy /etc/apt/apt.conf.d/01_proxy

ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini

# For Dojo:
# * entrypoint requires sudo and shadow
# * git is needed to install image configs
# * ca-certificated needed when running git clone to avoid this error:
# fatal: unable to access 'https://github.com/ai-traders/dojo.git/': Problem with the SSL CA cert (path? access rights?)
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  sudo git ca-certificates wget && \
  git clone --depth 1 -b 0.2.1 https://github.com/ai-traders/dojo.git /tmp/dojo_git &&\
  /tmp/dojo_git/image_scripts/src/install.sh && \
  rm -r /tmp/dojo_git && \
  echo 'dojo ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

COPY ./ca.crt /usr/local/share/ca-certificates/ait.crt
RUN update-ca-certificates

COPY etc_dojo.d/scripts/* /etc/dojo.d/scripts/
COPY etc_dojo.d/variables/* /etc/dojo.d/variables/

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

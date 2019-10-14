### 1.3.1 (2019-Oct-14)
Added Make

### 1.3.0 (2019-Oct-14)
Added lein to support clojure

### 1.2.0 (2019-Sep-13)
Fixes to support OSX.

### 1.1.0 (2019-May-18)
 * upgraded gradle to 5.4.1

### 1.0.1 (2019-Apr-28)

* fix handling empty `.ssh` directory

### 1.0.0 (2019-Apr-28)

Making a public image.
 * rename to `openjdk-dojo`
 * publish to dockerhub under `kudulab/openjdk-dojo`
 * shorter identity setup, all secrets are optional
 * use public scripts from kudulab
 * removed oversion
 * removed AIT CA
 * remove AIT APT proxy config
 * removed vault cli from image
 * removed sudo privileges
 * updated base image to `openjdk:8u212`
 * removed `CA_CERTIFICATES_JAVA_VERSION` variable, it is no longer present in the base image

### 0.6.0 (2019-Feb-03)

* transform from ide docker image to dojo docker image #17139
* no need for custom entrypoint - set java variables in etc/dojo.d/variables/
* pretty bash prompt
* releaser 1.1.0, docker-ops 0.3.3

### 0.5.0 (2018-Sep-10)

 * added optional k8s secrets setup on container start

### 0.4.0 (2018-Sep-05)

 * upgrade to gradle 4.10

### 0.3.2 (2018-Sep-05)

 * updated base image
 * switch to build tools without ruby
 * removed warmup, java projects are updated so rarely that it wasn't helping anyway

### 0.3.1 (11 Oct 2016)

* #9994 added warm up stage

### 0.3.0 (10 Oct 2016)

* #10022 switch to gradle 2.14.1 due to unresolvable BOM importing problems

### 0.2.0 (8 Oct 2016)

Switch base image from alpine to debian/ubuntu, because it is hard now (impossible?)
 to create java-gide image based on java-ide image. Reasons in #9988.

### 0.1.0 (3 Oct 2016)

Initial release of docker-java-ide

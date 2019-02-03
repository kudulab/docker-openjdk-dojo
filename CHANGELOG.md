* transform from ide docker image to dojo docker image #17139
* no need for custom entrypoint - set java variables in etc/dojo.d/variables/

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

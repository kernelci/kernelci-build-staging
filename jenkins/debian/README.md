# Creation of Debian-based base ramdisks

All the Jenkinsfiles from this directory defines a Jenkins Pipeline creating
stripped-down Debian base images for x86, x86_64, armel and arm64.
* Jenkinsfile_basic only creates the stripped down debian images
* Jenkinsfile_igt creates the debian image with the IGT test suite
* Jenkinsfile_v4l2 creates the debian image with the test utils from v4l-utils

These images are created using [debos](https://github.com/go-debos/debos)
that's installed with all its dependencies in the docker image used by
the pipeline.

The pipeline has been tested in a Jenkins installation setup using docker
as agents.
At least the following Jenkins plugins must be installed:

- [pipeline](https://wiki.jenkins-ci.org/display/JENKINS/Pipeline+Plugin)
- [docker pipeline](http://wiki.jenkins-ci.org/display/JENKINS/Docker+Pipeline+Plugin)
- [version number](https://wiki.jenkins-ci.org/display/JENKINS/Version+Number+Plugin)

debos also needs the kvm module loaded by the build host.


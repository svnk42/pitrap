piTrap
======

# Description

piTrap is a simple Docker image containing [arpwatch](http://linux.die.net/man/8/arpwatch "arpwatch") and [pyscanlogd](https://github.com/pythonhacker/pyscanlogd "pyscanlogd"), which can be configured to send the respective log files to an external syslog server. The purpose of piTrap is to monitor network segments for suspicious activity and trigger alerts via an external syslog server.

In the current version only logging to the [Papertrail](https://papertrailapp.com/ "papertrail") backend is preconfigured. I'm currently evaluating others, so feel free to send suggestions.

The idea behind piTrap is not new. In fact, I got inspired by an article from 1998 in the [Phrack Magazine](http://phrack.org/issues/53/13.html#article "phrack") and the relatively new [Thinkst Canaries](https://canary.tools/ "thinkst"). I wanted to have a solution that is preferably portable and runs also on small devices, such as the Raspberry Pi.

_Disclaimer_: I just put all the stuff together, so credits should go to the developers of arpwatch and pyscanlogd.

_Note_: This Docker image is in a very early stage and should not be used in a production environment. The image uses the `host` network, which allows access to local network services. Don't run this image on a critical or important host.

# Base image

The Docker base image is based on an Raspbian image provided by [resin](https://hub.docker.com/r/resin/rpi-raspbian/) for the Raspberry Pi. This base image was upgraded and saved in a separate Docker Hub repository.

I used a current version of [Arch Linux for the Raspberry Pi](https://wiki.archlinux.org/index.php/Raspberry_Pi) as the Raspberry Pi OS. Docker can easily be installed via the `pacman` package management tool.

```bash
$ pacman -S docker
```

# Log Management Configuration

In the current version only [Papertrail](https://papertrailapp.com/ "papertrail") can be used as a remote syslog backend. It is not hard to reconfigure the Dockerfile for alternative syslog servers, but Papertrail should work out-of-the-box.

The Papertrail host and port configuration is passed to the image via the environment variable `LOG_ENDPOINT` (see [Running the docker image](#running)).

## papertrail bundle

Logging to Papertrail is configured using a TLS connection, so the certificate bundle needs to be included in the Docker configuration. The bundle was downloaded from [https://papertrailapp.com/tools/papertrail-bundle.pem].

It is recommended to check for any changes in the [Papertrail documentation](http://help.papertrailapp.com/kb/configuration/encrypting-remote-syslog-with-tls-ssl/).

# Setting the hostname

You can set the hostname of the image via the `HOSTNAME` environment variable (see [Running the docker image](#running)). By default the hostname is set to `pitrap`.

# Build the image

To build this Docker container just run

```bash
$ docker build -t <name>:<tag> .
```


If you don't want to build it yourself, you can pull it from Docker Hub.

```bash
$ docker pull svnk/pitrap
```

# <a name="running"></a>Running the docker image

The following command can be used to run the Docker image:

```bash
$ docker run -d
  --restart=unless-stopped \
  --cap-add=SYS_ADMIN \
  --env HOSTNAME=myhostname
  --env LOG_ENDPOINT=<papertrail-host:port> \
  --net=host \
  pitrap:v0.7
```

* `SYS_ADMIN` is required to set the hostname, if you don't need this, leave it out.
* `HOSTNAME` will be the hostname (surprise...)
* `LOG_ENDPOINT` is the log destination (host and port) as provided by Papertrail.
* `--net=host` is required to access the ethernet interface. The network stack will not be containerized and allows the container access to local network services

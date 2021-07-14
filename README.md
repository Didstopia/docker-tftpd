Tftpd Docker Image
==================

**NOTE:** This is a fork of [wastrachan/docker-tftpd](https://github.com/wastrachan/docker-tftpd) with a few additions, such as control over `tftpd` verbosity.

Tftpd in a Docker container, with data directory in a volume, and a configurable UID/GID for data files.

![GitHub Actions](https://github.com/Didstopia/docker-tftpd/actions/workflows/ci.yml/badge.svg)
[![](https://img.shields.io/docker/pulls/didstopia/tftpd.svg)](https://hub.docker.com/r/didstopia/tftpd)

## Install

#### Docker Hub
Pull the latest image from Docker Hub:

```shell
docker pull didstopia/tftpd:latest
```

#### Manually
Clone this repository, and run `make build` to build an image:

```shell
git clone https://github.com/Didstopia/docker-tftpd.git
cd docker-tftpd
make build
```

If you need to rebuild the image, run `make clean build`.


## Run

#### Docker
Run this image with the `make run` shortcut, or manually with `docker run`.


```shell
docker run -v "$(pwd)/data:/data" \
           --name tftpd \
           -p 69:69/udp \
           -e PUID=1111 \
           -e PGID=1112 \
           -e TFTPD_DEBUG=true \
           --restart unless-stopped \
           didstopia/tftpd:latest
```


#### Docker Compose
If you wish to run this image with docker-compose, an example `docker-compose.yml` might read as follows:

```yaml
---
version: "2"

services:
  tftpd:
    image: didstopia/tftpd:latest
    container_name: tftpd
    environment:
      - PUID=1111
      - PGID=1112
      - TFTPD_DEBUG=true
    volumes:
      - </path/to/data>:/data
    ports:
      - 69:69/udp
    restart: unless-stopped
```


## Configuration

#### User / Group Identifiers
If you'd like to override the UID and GID of the `tftpd` process, you can do so with the environment variables `PUID` and `PGID`. This is helpful if other containers must access your configuration volume.

#### Services
Service     | Port
------------|-----
TFTPD       | 69


#### Volumes
Volume          | Description
----------------|-------------
`/data`         | Data directory for files served by tftpd


## License
The content of this project itself is licensed under the [MIT License](LICENSE).

View [license information](https://www.isc.org/downloads/software-support-policy/isc-license/) for the software contained in this image.

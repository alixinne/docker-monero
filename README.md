# [docker-monero](https://github.com/alixinne/docker-monero)

[![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/alixinne/docker-monero/build.yaml)](https://github.com/alixinne/docker-monero/actions/workflows/build.yaml)
[![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/alixinne/docker-monero/update.yaml)](https://github.com/alixinne/docker-monero/actions/workflows/update.yaml)

This is a repository to build a Docker image of the
[Monero](https://www.getmonero.org/) cryptocurrency tools. It is geared towards
running a full node, but feel free to use this image as a base for building
your own applications.

## Running

Using Docker:
```bash
docker run -v $PWD/data:/opt/monero/data \ # Data directory for storing the blockchain
           -p 18080:18080/tcp \ # (Optional) Expose daemon ports
           -p 18081:18081/tcp \
           -e RUN_AS=999:999 \  # (Optional) UID:GID to run monerod as
           ghcr.io/alixinne/monero:latest
```

## Author

* Docker image: [Alixinne](https://github.com/alixinne)
* Monero software: [Monero Project](https://github.com/monero-project)

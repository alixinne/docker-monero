FROM debian:bullseye-slim AS build-stage

# GPG key fingerprint for verifying downloaded artifacts
ARG MONERO_KEY_FP=81AC591FE9C4B65C5806AFC3F0AF4D462A0BDF92

RUN DEBIAN_FRONTEND=noninteractive apt-get update -q \
 && apt-get install --no-install-recommends -y ca-certificates curl gpg gpg-agent tar bzip2 \
 && curl --progress-bar -fsSL https://raw.githubusercontent.com/monero-project/monero/master/utils/gpg_keys/binaryfate.asc | gpg --import \
 && echo -e "4\ny\n" | gpg --batch --command-fd 0 --expert --edit-key "${MONERO_KEY_FP}" trust \
 && echo "Imported monero project GPG key"

RUN curl --progress-bar -fsSL -o/tmp/hashes.txt https://www.getmonero.org/downloads/hashes.txt \
 && gpg --verify /tmp/hashes.txt \
 && echo "Hashes successfully verified!"

# Platform to download monero for
ARG MONERO_PLATFORM=linux-x64
# Monero version
ARG MONERO_VERSION=0.18.3.3

RUN curl --progress-bar -fsSL -o/tmp/monero-${MONERO_PLATFORM}-v${MONERO_VERSION}.tar.bz2 https://downloads.getmonero.org/cli/monero-${MONERO_PLATFORM}-v${MONERO_VERSION}.tar.bz2 \
 && grep $(sha256sum /tmp/monero-${MONERO_PLATFORM}-v${MONERO_VERSION}.tar.bz2 | cut -c 1-64) /tmp/hashes.txt \
 && echo "Verified monero ${MONERO_VERSION} download"

RUN tar -C /opt --strip-components=1 --one-top-level=monero -xvf /tmp/monero-${MONERO_PLATFORM}-v${MONERO_VERSION}.tar.bz2

FROM debian:bullseye-slim AS run-stage

COPY --from=build-stage /opt/monero /opt/monero
COPY start-monerod.sh /opt/monero

WORKDIR /opt/monero
ENV PATH=/opt/monero:/usr/local/bin:/usr/bin:/bin
CMD ["/opt/monero/start-monerod.sh"]

EXPOSE 18080-18081/tcp

FROM 2chevskii/steamcmd:debian-12.10-slim AS download

RUN /steamcmd/steamcmd.sh +force_install_dir /rust-dedicated-server +login anonymous +app_update 258550 validate +quit

FROM debian:12.10-slim

ARG CREATION_TIME
ARG BRANCH_NAME
ARG COMMIT_HASH

LABEL org.opencontainers.image.title="Rust Dedicated Server"
LABEL org.opencontainers.image.description="Rust dedicated server Docker image"

LABEL org.opencontainers.image.created="$CREATION_TIME"

LABEL org.opencontainers.image.authors="dvchevskii@gmail.com"
LABEL org.opencontainers.image.url="https://github.com/2chevskii/rustds-docker"
LABEL org.opencontainers.image.source="https://github.com/2chevskii/rustds-docker.git"
LABEL org.opencontainers.image.vendor="2CHEVSKII"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.documentation="https://github.com/2chevskii/rustds-docker/wiki"

LABEL org.opencontainers.image.ref.name="$BRANCH_NAME"
LABEL org.opencontainers.image.revision="$COMMIT_HASH"

ENV SERVER_DIR=/rust-dedicated-server

WORKDIR $SERVER_DIR
COPY --from=download /rust-dedicated-server .

RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y ca-certificates wget && \
  apt-get autoclean -y && \
  apt-get autoremove -y

ADD --chmod=755 https://github.com/vi/websocat/releases/latest/download/websocat.x86_64-unknown-linux-musl /usr/local/bin/websocat

COPY --chmod=755 docker-entrypoint.sh /docker-entrypoint.sh

ENV LOGFILE=/var/log/rust-dedicated-server/server.log

RUN mkdir -p "$(dirname "$LOGFILE")" && \
  ln -sf /dev/stdout "$LOGFILE"

ENV SERVER_PORT=28015
ENV QUERY_PORT=28016
ENV RCON_PORT=28015
ENV COMPANIONAPP_PORT=28082

EXPOSE $SERVER_PORT/udp
EXPOSE $QUERY_PORT/udp
EXPOSE $RCON_PORT/tcp
EXPOSE $COMPANIONAPP_PORT/tcp

ENV SERVER_IDENTITY=default

# switch networking mode
# available values: "raknet", "swnet", "sdrnet"
ENV NETWORK_MODE=raknet
ENV NETWORK_SINGLETHREADED=false

# server occlusion culling mode
# available values: "full", "norocks", "none"
ENV SERVER_OCCLUSION_MODE=full

ENV NOSTEAM=false

ENV NOPERF=true

ENV RCON_PRINT=true

ENTRYPOINT ["/docker-entrypoint.sh"]

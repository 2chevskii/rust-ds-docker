FROM 2chevskii/rust-dedicated-server:vanilla

ARG OXIDE_DIST_URL=https://github.com/OxideMod/Oxide.Rust/releases/latest/download/Oxide.Rust-linux.zip

RUN apt-get install -y unzip

ADD $OXIDE_DIST_URL /oxide_rust_linux.zip
RUN unzip -od $SERVER_DIR /oxide_rust_linux.zip && rm /oxide_rust_linux.zip

ENTRYPOINT [ "/docker-entrypoint.sh" ]

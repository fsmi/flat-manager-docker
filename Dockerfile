FROM docker.io/rust:trixie as builder

RUN apt-get update && apt-get install -y libpq-dev libostree-dev

COPY flat-manager /src

RUN cd /src && cargo build --release

FROM docker.io/debian:trixie

RUN apt-get update && apt-get install -y flatpak ostree libpq5 ca-certificates && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /src/target/release/flat-manager /src/target/release/flat-manager-client /usr/local/bin/
CMD ["flat-manager"]

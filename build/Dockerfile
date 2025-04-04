FROM --platform=$TARGETPLATFORM debian:bookworm-slim as artifact
ENV ZITADEL_ARGS=
ARG TARGETPLATFORM

RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl && \
    curl -1sLf 'https://dl.cloudsmith.io/public/infisical/infisical-cli/setup.deb.sh' | bash && \
    apt-get install -y infisical && \
    rm -rf /var/lib/apt/lists/*

COPY build/entrypoint.sh /app/original-entrypoint.sh
COPY build/infisical-entrypoint.sh /app/entrypoint.sh
COPY zitadel /app/zitadel


RUN useradd -s "" --home / zitadel && \
    chown zitadel /app/zitadel && \
    chmod +x /app/zitadel && \
    chown zitadel /app/entrypoint.sh && \
    chmod +x /app/entrypoint.sh && \
    chown zitadel /app/original-entrypoint.sh && \
    chmod +x /app/original-entrypoint.sh

WORKDIR /app
ENV PATH="/app:${PATH}"

USER zitadel
ENTRYPOINT ["/app/entrypoint.sh"]

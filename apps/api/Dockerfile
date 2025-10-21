# Builder stage: Sets up the environment, installs dependencies, copies the Zitadel binary, and configures permissions for the application.
# This stage produces a runnable image that can be used for debugging.
FROM debian:12-slim AS builder
ARG TARGETPLATFORM

RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl && \
    curl -1sLf 'https://dl.cloudsmith.io/public/infisical/infisical-cli/setup.deb.sh' | bash && \
    apt-get install -y infisical && \
    rm -rf /var/lib/apt/lists/*

COPY apps/api/entrypoint.sh /app/original-entrypoint.sh
COPY apps/api/infisical-entrypoint.sh /app/entrypoint.sh
COPY ./.artifacts/bin/${TARGETPLATFORM}/zitadel.local /app/zitadel

RUN useradd -s "" --home / zitadel && \
    chown zitadel /app/zitadel && \
    chmod +x /app/zitadel && \
    chown zitadel /app/entrypoint.sh && \
    chmod +x /app/entrypoint.sh && \
    chown zitadel /app/original-entrypoint.sh && \
    chmod +x /app/original-entrypoint.sh

WORKDIR /app
ENV PATH="/app:${PATH}"

HEALTHCHECK NONE
EXPOSE 8080

USER zitadel
ENTRYPOINT ["/app/entrypoint.sh"]

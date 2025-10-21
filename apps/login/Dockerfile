FROM node:24-alpine AS base

FROM base AS build
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable && COREPACK_ENABLE_DOWNLOAD_PROMPT=0 corepack prepare pnpm@10.13.1 --activate && \
    apk update && \
    rm -rf /var/cache/apk/*
WORKDIR /app
RUN addgroup --system --gid 1001 nodejs && \
    adduser --system --uid 1001 nextjs
# If /.env-file/.env is mounted into the container, its variables are made available to the server before it starts up.
RUN mkdir -p /.env-file && touch /.env-file/.env && chown -R nextjs:nodejs /.env-file

COPY --chown=nextjs:nodejs .next/standalone ./

USER nextjs
ENV HOSTNAME="0.0.0.0" \
    PORT="3000" \
    NODE_ENV="production"

# TODO: Check healthy, not ready
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD ["/bin/sh", "-c", "node /app/healthcheck.js http://localhost:${PORT}/ui/v2/login/healthy"]
ENTRYPOINT ["/app/entrypoint.sh", "node", "apps/login/server.js" ]

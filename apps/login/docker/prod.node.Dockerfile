FROM node:24-alpine AS builder

ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

RUN corepack enable && COREPACK_ENABLE_DOWNLOAD_PROMPT=0 corepack prepare pnpm@10.13.1 --activate && \
    apk update && \
    rm -rf /var/cache/apk/*

WORKDIR /var/www/frontend

RUN mkdir -p ./apps/login/node_modules \
    && mkdir -p ./apps/login/.next \
    && addgroup --system --gid 1001 nodejs \
    && adduser --system --uid 1001 nextjs \
    && chown -R nextjs:nodejs ./

COPY --chown=nextjs:nodejs pnpm-workspace.yaml ./pnpm-workspace.yaml
COPY --chown=nextjs:nodejs packages ./packages
COPY --chown=nextjs:nodejs proto ./proto
COPY --chown=nextjs:nodejs apps/login/package.json ./apps/login/package.json

USER nextjs

RUN --mount=type=cache,id=pnpm,target=/home/nextjs/.local/share/pnpm/store pnpm install
RUN pnpm --filter @zitadel/proto run generate && pnpm --filter @zitadel/client run build

COPY --chown=nextjs:nodejs apps/login/tsconfig.json ./apps/login/tsconfig.json
COPY --chown=nextjs:nodejs apps/login/next.config.mjs ./apps/login/next.config.mjs
COPY --chown=nextjs:nodejs apps/login/postcss.config.cjs ./apps/login/postcss.config.cjs
COPY --chown=nextjs:nodejs apps/login/tailwind.config.mjs ./apps/login/tailwind.config.mjs
COPY --chown=nextjs:nodejs apps/login/src ./apps/login/src
COPY --chown=nextjs:nodejs apps/login/public ./apps/login/public
COPY --chown=nextjs:nodejs apps/login/scripts ./apps/login/scripts
COPY --chown=nextjs:nodejs apps/login/locales ./apps/login/locales
COPY --chown=nextjs:nodejs apps/login/constants ./apps/login/constants

ENV INFRA_ENV=production
ENV NODE_ENV=production

WORKDIR /var/www/frontend/apps/login

RUN pnpm build

FROM node:24-alpine AS runner

RUN apk update && \
    apk add --no-cache curl bash && \
    curl -1sLf 'https://dl.cloudsmith.io/public/infisical/infisical-cli/setup.alpine.sh' | distro=alpine version=3.22.2 bash && \
    apk add --no-cache infisical && \
    rm -rf /var/cache/apk/*

WORKDIR /var/www/frontend/

RUN addgroup --system --gid 1001 nodejs && \
    adduser --system --uid 1001 nextjs

COPY --chown=nextjs:nodejs apps/login/docker/entrypoint.sh /entrypoint.sh
COPY --from=builder --chown=nextjs:nodejs /var/www/frontend/apps/login/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /var/www/frontend/apps/login/.next/static ./.next/static
COPY --from=builder --chown=nextjs:nodejs /var/www/frontend/apps/login/public ./public
    
RUN chmod +x /entrypoint.sh 

USER nextjs

ENV HOSTNAME="0.0.0.0" \
    PORT=3000

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD ["/bin/sh", "-c", "curl -f http://localhost:${PORT}/healthy || exit 1"]

ENTRYPOINT ["/entrypoint.sh"]
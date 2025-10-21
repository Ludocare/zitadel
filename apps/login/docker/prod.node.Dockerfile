FROM node:24-alpine AS builder

ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

RUN corepack enable && COREPACK_ENABLE_DOWNLOAD_PROMPT=0 corepack prepare pnpm@10.13.1 --activate && \
    apk update && \
    rm -rf /var/cache/apk/*

WORKDIR /var/www/frontend

COPY package.json pnpm-lock.yaml ./

RUN --mount=type=cache,id=pnpm,target=/root/.local/share/pnpm/store pnpm install --frozen-lockfile

COPY tsconfig.json next.config.mjs postcss.config.cjs tailwind.config.mjs ./
COPY ./src ./src
COPY ./public ./public
COPY ./locales ./locales
COPY ./constants ./constants

ENV INFRA_ENV=production

RUN pnpm build:login:standalone

FROM node:24-alpine AS runner

RUN apk update && \
    apk add --no-cache curl bash && \
    curl -1sLf 'https://dl.cloudsmith.io/public/infisical/infisical-cli/setup.alpine.sh' | bash && \
    apk add --no-cache infisical && \
    rm -rf /var/cache/apk/*

WORKDIR /var/www/frontend

RUN addgroup --system --gid 1001 nodejs && \
    adduser --system --uid 1001 nextjs

COPY --chown=nextjs:nodejs ./docker/entrypoint.sh /entrypoint.sh
COPY --from=builder --chown=nextjs:nodejs /var/www/frontend/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /var/www/frontend/.next/static ./.next/static
COPY --from=builder --chown=nextjs:nodejs /var/www/frontend/public ./public

RUN chmod +x /entrypoint.sh 

USER nextjs

ENV HOSTNAME="0.0.0.0" \
    PORT=3000

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD ["/bin/sh", "-c", "curl -f http://localhost:${PORT}/healthy || exit 1"]

ENTRYPOINT ["/entrypoint.sh"]
FROM node:24-alpine AS dev

ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

RUN corepack enable && COREPACK_ENABLE_DOWNLOAD_PROMPT=0 corepack prepare pnpm@10.13.1 --activate && \
    apk update && \
    apk add --no-cache curl sudo && \
    rm -rf /var/cache/apk/*

RUN mkdir -p /var/www/frontend/node_modules \
    && mkdir -p /var/www/frontend/.next \
    && addgroup --system --gid 1001 nodejs \
    && adduser --system --uid 1001 nextjs \
    && echo "nextjs ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
    && chown -R nextjs:nodejs /var/www/frontend

WORKDIR /var/www/frontend

COPY --chown=nextjs:nodejs package.json pnpm-lock.yaml ./

USER nextjs

RUN --mount=type=cache,id=pnpm,target=/home/nextjs/.local/share/pnpm/store pnpm install --frozen-lockfile

COPY --chown=nextjs:nodejs tsconfig.json next.config.mjs postcss.config.cjs tailwind.config.mjs ./
COPY --chown=nextjs:nodejs ./src ./src
COPY --chown=nextjs:nodejs ./public ./public
COPY --chown=nextjs:nodejs ./locales ./locales
COPY --chown=nextjs:nodejs ./constants ./constants

ENV INFRA_ENV=development

# Create an entrypoint script to handle permissions
COPY --chown=nextjs:nodejs ./docker/dev-entrypoint.sh /dev-entrypoint.sh
RUN chmod +x /dev-entrypoint.sh

ENTRYPOINT ["/dev-entrypoint.sh"]
CMD ["pnpm", "dev"]
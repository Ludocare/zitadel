FROM node:24-alpine AS dev

ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

RUN corepack enable && COREPACK_ENABLE_DOWNLOAD_PROMPT=0 corepack prepare pnpm@10.13.1 --activate && \
    apk update && \
    apk add --no-cache curl sudo && \
    rm -rf /var/cache/apk/*

RUN mkdir -p /workspace/apps/login/node_modules \
    && mkdir -p /workspace/apps/login/.next \
    && addgroup --system --gid 1001 nodejs \
    && adduser --system --uid 1001 nextjs \
    && echo "nextjs ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
    && chown -R nextjs:nodejs /workspace

WORKDIR /workspace/apps/login

COPY --chown=nextjs:nodejs pnpm-workspace.yaml /workspace/pnpm-workspace.yaml
COPY --chown=nextjs:nodejs packages /workspace/packages
COPY --chown=nextjs:nodejs proto /workspace/proto
COPY --chown=nextjs:nodejs apps/login/package.json /workspace/apps/login/package.json
COPY --chown=nextjs:nodejs apps/login/pnpm-lock.yaml /workspace/apps/login/pnpm-lock.yaml

USER nextjs

RUN --mount=type=cache,id=pnpm,target=/home/nextjs/.local/share/pnpm/store pnpm install
RUN pnpm --filter @zitadel/proto run generate && pnpm --filter @zitadel/client run build
USER root

COPY --chown=nextjs:nodejs apps/login/tsconfig.json /workspace/apps/login/tsconfig.json
COPY --chown=nextjs:nodejs apps/login/next.config.mjs /workspace/apps/login/next.config.mjs
COPY --chown=nextjs:nodejs apps/login/postcss.config.cjs /workspace/apps/login/postcss.config.cjs
COPY --chown=nextjs:nodejs apps/login/tailwind.config.mjs /workspace/apps/login/tailwind.config.mjs
COPY --chown=nextjs:nodejs apps/login/src /workspace/apps/login/src
COPY --chown=nextjs:nodejs apps/login/public /workspace/apps/login/public
COPY --chown=nextjs:nodejs apps/login/locales /workspace/apps/login/locales
COPY --chown=nextjs:nodejs apps/login/constants /workspace/apps/login/constants

ENV INFRA_ENV=development

COPY --chown=nextjs:nodejs apps/login/docker/dev-entrypoint.sh /dev-entrypoint.sh
RUN chmod +x /dev-entrypoint.sh

ENTRYPOINT ["/dev-entrypoint.sh"]
CMD ["pnpm", "dev"]
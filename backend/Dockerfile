# Install dependencies and build the application.
FROM node:24-alpine AS build

WORKDIR /app

RUN corepack enable

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
RUN pnpm install --frozen-lockfile

COPY . .
RUN pnpm build

# Install production dependencies only.
FROM node:24-alpine AS production-deps

WORKDIR /app

RUN corepack enable

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
RUN pnpm install --prod --frozen-lockfile

# Minimal runtime image.
FROM node:24-alpine AS production

ENV NODE_ENV=production
ENV PORT=3000

WORKDIR /app

COPY --from=production-deps --chown=node:node \
  /app/node_modules ./node_modules

COPY --from=build --chown=node:node \
  /app/dist ./dist

COPY --from=build --chown=node:node \
  /app/package.json ./package.json

USER node

EXPOSE 3000

CMD ["node", "dist/main.js"]
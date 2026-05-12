FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

FROM node:18-alpine

WORKDIR /app

RUN addgroup -g 1001 -S nodejs && \
    adduser -S -u 1001 -G nodejs nodeuser

COPY --from=builder /app/node_modules ./node_modules
COPY . .

RUN chown -R nodeuser:nodejs /app

USER nodeuser

EXPOSE 3000

ENV NODE_ENV=production
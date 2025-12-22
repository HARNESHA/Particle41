FROM node:20-alpine

ENV NODE_ENV=production

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

COPY package*.json ./

RUN npm ci --only=production && \
    npm cache clean --force

COPY app.js .

RUN chown -R appuser:appgroup /app

USER appuser

EXPOSE 3000

CMD ["node", "app.js"]

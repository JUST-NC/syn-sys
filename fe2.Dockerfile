FROM node:16-alpine AS builder
COPY backend/fe /app/
WORKDIR /app
RUN npm install --registry=https://npmmirror.com --legacy-peer-deps && export NODE_ENV=production && npm run build:prod

FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80
EXPOSE 443

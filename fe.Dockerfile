FROM node:16-alpine AS builder
COPY backend/ruoyi-ui /app/
WORKDIR /app
RUN npm install --registry=https://registry.npm.taobao.org --legacy-peer-deps && export NODE_ENV=production && npm run build:prod

# TODO: nginx.conf
# TODO: static files volume
FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80
EXPOSE 443

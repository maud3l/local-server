FROM caddy:2-builder AS builder

RUN xcaddy build \
  --with github.com/porech/caddy-maxmind-geolocation \
  --with github.com/lucaslorentz/caddy-docker-proxy/v2

FROM caddy:latest

COPY Caddyfile /etc/caddy/Caddyfile
COPY --from=builder /usr/bin/caddy /usr/bin/caddy

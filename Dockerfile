FROM caddy:builder AS builder
RUN xcaddy build \
    --with github.com/porech/caddy-maxmind-geolocation

FROM alpine:3.19 AS geodb
RUN apk add --no-cache curl \
 && curl -L -o /GeoLite2-ASN.mmdb https://git.io/GeoLite2-ASN.mmdb \
 && curl -L -o /GeoLite2-Country.mmdb https://git.io/GeoLite2-Country.mmdb

FROM caddy
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
COPY --from=geodb /GeoLite2-ASN.mmdb /GeoLite2-ASN.mmdb
COPY --from=geodb /GeoLite2-Country.mmdb /GeoLite2-Country.mmdb
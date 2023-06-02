FROM docker.io/grafana/promtail:latest
RUN apt update && apt install -y wget
RUN cd /var/lib; \
      mkdir -p geoip; \
      wget -O /var/lib/geoip/GeoLite2-City.mmdb https://github.com/P3TERX/GeoLite.mmdb/raw/download/GeoLite2-City.mmdb; \
      chown -R 200:200 geoip
RUN touch /root/positions.yaml
ADD promtail-config.yaml /mnt/config/promtail-config.yml
ENTRYPOINT ["/usr/bin/promtail","--config.file", "/mnt/config/promtail-config.yml"]

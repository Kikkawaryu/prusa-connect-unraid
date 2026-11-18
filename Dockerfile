FROM prusa-base

USER root
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       gosu \
       libgl1 \
       libgl1-mesa-dri \
       libwebkit2gtk-4.1-0 \
       libdbus-1-3 \
       xvfb \
    && rm -rf /var/lib/apt/lists/*

ENV APPIMAGE_EXTRACT_AND_RUN=1
ENV DISPLAY=:99

COPY default-config.yaml /defaults/config.yaml
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/prusa_connect", "core"]

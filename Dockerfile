FROM golang:1.26-alpine AS builder
ARG PRUSA_TAG=main
RUN apk add --no-cache git nodejs npm pnpm make bash
RUN git clone --depth 1 --branch "${PRUSA_TAG}" https://github.com/prusa3d/prusa-connect.git /src
WORKDIR /src
RUN if [ -f Makefile ]; then make build || true; fi && \
    if [ ! -f /prusa_connect ] && [ ! -f bin/prusa_connect ]; then \
      if [ -f frontend/package.json ]; then cd frontend && pnpm install --ignore-scripts=false && pnpm run build && cd /src; fi && \
      CGO_ENABLED=0 go build -o /prusa_connect ./cmd/prusa_connect; \
    elif [ -f bin/prusa_connect ]; then \
      cp bin/prusa_connect /prusa_connect; \
    fi

FROM alpine:latest
RUN apk add --no-cache ca-certificates tzdata util-linux
COPY --from=builder /prusa_connect /prusa_connect
COPY --from=builder /src/config/config.yaml /opt/default-config.yaml
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
EXPOSE 8080
ENTRYPOINT ["/entrypoint.sh"]
CMD ["core"]

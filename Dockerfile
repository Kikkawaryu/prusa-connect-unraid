FROM golang:1.26-alpine AS builder
ARG PRUSA_TAG=main
RUN apk add --no-cache git nodejs npm pnpm make bash
RUN git clone --depth 1 --branch "${PRUSA_TAG}" https://github.com/prusa3d/prusa-connect.git /src
WORKDIR /src
RUN for pkg in packages/* packages/*/*; do \
      if [ -f "$pkg/package.json" ]; then \
        (cd "$pkg" && pnpm install && pnpm run --if-present build); \
      fi; \
    done && \
    cd frontend && pnpm install && pnpm run build
RUN MAIN_PKG=$(dirname $(find ./cmd -name "main.go" | head -n 1)) && \
    echo "Building Go package from: ${MAIN_PKG:-.}" && \
    CGO_ENABLED=0 go build -o /prusa_connect "${MAIN_PKG:-.}" && \
    mkdir -p /out && \
    if [ -f config/config.yaml ]; then cp config/config.yaml /out/default-config.yaml; \
    else find . -name "config.yaml" -exec cp {} /out/default-config.yaml \; -quit; fi && \
    touch /out/default-config.yaml

FROM alpine:latest
RUN apk add --no-cache ca-certificates tzdata util-linux && \
    addgroup -g 10001 -S prusa && \
    adduser -u 10001 -S -G prusa -H -s /sbin/nologin prusa
COPY --from=builder /prusa_connect /prusa_connect
COPY --from=builder /out/default-config.yaml /opt/default-config.yaml
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
EXPOSE 8080
ENTRYPOINT ["/entrypoint.sh"]
CMD ["core"]

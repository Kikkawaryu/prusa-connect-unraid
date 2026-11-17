FROM golang:1.26-alpine AS builder
ARG PRUSA_TAG=main
RUN apk add --no-cache git nodejs npm pnpm make bash
RUN git clone --depth 1 --branch "${PRUSA_TAG}" https://github.com/prusa3d/prusa-connect.git /src
WORKDIR /src
RUN if [ -f pnpm-workspace.yaml ]; then \
      pnpm install && pnpm -r --filter "./packages/*" run build && pnpm --filter "./frontend" run build; \
    elif [ -f frontend/package.json ]; then \
      for pkg in packages/*; do [ -f "$pkg/package.json" ] && (cd "$pkg" && pnpm install && pnpm run build); done && \
      cd frontend && pnpm install && pnpm run build; \
    fi
RUN CGO_ENABLED=0 go build -o /prusa_connect ./cmd/prusa_connect

FROM alpine:latest
RUN apk add --no-cache ca-certificates tzdata util-linux
COPY --from=builder /prusa_connect /prusa_connect
COPY --from=builder /src/config/config.yaml /opt/default-config.yaml
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
EXPOSE 8080
ENTRYPOINT ["/entrypoint.sh"]
CMD ["core"]

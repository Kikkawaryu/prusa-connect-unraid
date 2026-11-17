FROM golang:1.26-alpine AS builder
ARG PRUSA_TAG=main
RUN apk add --no-cache git nodejs npm make
RUN corepack enable && corepack prepare pnpm@latest --activate
RUN git clone --depth 1 --branch "${PRUSA_TAG}" https://github.com/prusa3d/prusa-connect.git /src
WORKDIR /src
RUN if [ -f frontend/package.json ]; then cd frontend && pnpm install --frozen-lockfile || pnpm install && pnpm run build; fi
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

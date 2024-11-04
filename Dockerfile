ARG ARCH="amd64"
ARG OS="linux"

FROM golang:1.22-bullseye AS builder
# 安装最新版本的Delve调试工具
RUN go install github.com/go-delve/delve/cmd/dlv@latest

FROM debian:bullseye-slim
COPY --from=builder /go/bin/dlv /bin/dlv
COPY ./cmd/process-exporter/process_exporter /bin/process_exporter
COPY ./config.yml /bin/config.yml
RUN chmod +x /bin/process_exporter
EXPOSE 9256
EXPOSE 2345
USER root
CMD ["/bin/dlv", "exec", "/bin/process_exporter", "--headless", "--listen=:2345", "--api-version=2", "--accept-multiclient", "--", "--config.path=/bin/config.yml"]

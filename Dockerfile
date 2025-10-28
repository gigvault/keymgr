FROM golang:1.23-bullseye AS builder
WORKDIR /src

# Copy shared library first
COPY shared/ ./shared/

# Copy service files
COPY keymgr/go.mod keymgr/go.sum ./keymgr/
WORKDIR /src/keymgr
RUN go mod download

WORKDIR /src
COPY keymgr/ ./keymgr/
WORKDIR /src/keymgr
RUN CGO_ENABLED=0 GOOS=linux go build -o /out/keymgr ./cmd/keymgr

FROM alpine:3.18
RUN apk add --no-cache ca-certificates
COPY --from=builder /out/keymgr /usr/local/bin/keymgr
COPY keymgr/config/ /config/
EXPOSE 8080 9090
ENTRYPOINT ["/usr/local/bin/keymgr"]

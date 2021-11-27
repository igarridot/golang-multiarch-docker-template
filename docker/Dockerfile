ARG GOLANG_VERSION=$GOLANG_VERSION
FROM golang:$GOLANG_VERSION AS builder
ARG PROJECT_NAME
ENV PROJECT_NAME=${PROJECT_NAME}
ARG TARGETARCH
ARG TARGETOS

RUN \
    apt update && \
    apt install -y make git && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /go/src
COPY ./src ./
RUN \
    CGO_ENABLED=0 \
    GOOS=${TARGETOS} \
    GOARCH=${TARGETARCH} \
    go build -a -installsuffix cgo -o bin/${PROJECT_NAME}

FROM scratch
ARG PROJECT_NAME
ENV PROJECT_NAME=${PROJECT_NAME}
COPY --from=builder /go/src/bin/${PROJECT_NAME} /docker-entrypoint
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT [ "/docker-entrypoint" ]

FROM golang:1.17-alpine as builder

RUN apk update && apk add --no-cache git ca-certificates tzdata && update-ca-certificates

ENV USER=appuser
ENV UID=10001

ENV GOOS=linux
ENV CGO_ENABLED=0
ENV GO111MODULE=on

RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    "${USER}"
WORKDIR $GOPATH/src/app/
COPY ./go.mod ./go.sum ./
COPY ./vendor ./vendor
RUN go install ./vendor/...

COPY . .

ARG VERSION
ARG COMMIT_HASH
ARG BUILD_TIMESTAMP

RUN go build -ldflags="-X main.Version=$VERSION -X main.CommitHash=${COMMIT_HASH} -X main.BuildTimestamp=${BUILD_TIMESTAMP}" -o /go/bin/app .

FROM scratch
# EXPOSE 8080
COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group
COPY --from=builder /go/bin/app /go/bin/app

USER appuser:appuser

ENTRYPOINT ["/go/bin/app"]

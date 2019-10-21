# Build the manager binary
FROM golang:1.12.10-alpine3.10 as builder

# Copy in the go src
WORKDIR /go/src/github.com/open-policy-agent/gatekeeper
COPY pkg/    pkg/
COPY cmd/    cmd/
COPY vendor/ vendor/

# Build
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o manager github.com/open-policy-agent/gatekeeper/cmd/manager

# Copy the controller-manager into a thin image
FROM alpine:3.10.2

# Update image and add a non-root user
RUN apk update --no-cache &&\
    apk upgrade --no-cache &&\
    addgroup -S manager &&\
    adduser -h /home/manager -S -u 1000 -G manager manager
# TODO: check if -D (no password) option is needed

WORKDIR /home/manager/
COPY --chown=manager:manager --from=builder /go/src/github.com/open-policy-agent/gatekeeper/manager .
#RUN chown manager:manager manager

USER 1000

ENTRYPOINT ["./manager"]

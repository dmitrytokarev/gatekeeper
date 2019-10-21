# Build the manager binary
FROM golang:1.12.10-alpine3.10 as builder

RUN apk update --no-cache &&\
    apk upgrade --no-cache &&\
    apk add curl make --no-cache
# TODO: look what's in debian's apt-utils package that may be needed to be installed on alpine
# apt-get install -y apt-utils

# Install kubebuilder
WORKDIR /scratch
ENV version=1.0.8
ENV arch=amd64
RUN curl -L -O "https://github.com/kubernetes-sigs/kubebuilder/releases/download/v${version}/kubebuilder_${version}_linux_${arch}.tar.gz" &&\
    tar -zxvf kubebuilder_${version}_linux_${arch}.tar.gz &&\
    mv kubebuilder_${version}_linux_${arch} /usr/local/kubebuilder &&\
    rm kubebuilder_${version}_linux_${arch}.tar.gz
ENV PATH=$PATH:/usr/local/kubebuilder/bin:/usr/bin

# Install kustomize
ENV version=3.0.2
ENV arch=amd64
RUN curl -L -O "https://github.com/kubernetes-sigs/kustomize/releases/download/v${version}/kustomize_${version}_linux_${arch}" &&\
    mv kustomize_${version}_linux_${arch} /usr/bin/kustomize &&\
    chmod u+x /usr/bin/kustomize

# Copy in the go src
WORKDIR /go/src/github.com/open-policy-agent/gatekeeper
COPY .    .

ENTRYPOINT ["make", "native-test"]

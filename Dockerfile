FROM golang:1.19 AS builder
ARG OS=linux
ARG ARCH=amd64
WORKDIR /go/src/open-cluster-management.io/registration-operator
COPY . .
ENV GO_PACKAGE open-cluster-management.io/registration-operator
RUN GOOS=${OS} \
    GOARCH=${ARCH} \
        make build --warn-undefined-variables

FROM registry.access.redhat.com/ubi8/ubi-minimal:latest
ENV USER_UID=10001

COPY --from=builder /go/src/open-cluster-management.io/registration-operator/registration-operator /

USER ${USER_UID}

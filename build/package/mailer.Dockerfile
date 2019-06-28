# syntax=docker/dockerfile:experimental

FROM golang:1.11-alpine AS base_builder

# Install some dependencies needed to build the project
RUN --mount=type=cache,target=/var/cache/apk \
    apk add bash git gcc g++ libc-dev
WORKDIR /go/src/github.com/ImNotAVirus/YouTube.ex/cmd/mailer

# Force the go compiler to use modules
ENV GO111MODULE=on

# We want to populate the module cache based on the go.{mod,sum} files
COPY go.mod .
COPY go.sum .

#This is the ‘magic’ step that will download all the dependencies that are specified in
# the go.mod and go.sum file.
# Because of how the layer caching system works in Docker, the  go mod download
# command will _ only_ be re-run when the go.mod or go.sum file change
# (or when we add another docker instruction this line)
RUN go mod download

# Here we copy the rest of the source code
COPY . .
# And compile the project
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go install ./cmd/mailer

FROM alpine

WORKDIR /opt/mailer

# Gin production mode
ENV GIN_MODE=release

# Finally we copy the statically compiled Go binary
RUN mkdir /opt/mailer/bin
COPY --from=base_builder \
    /go/bin/mailer /opt/mailer/bin/
ENV PATH=/opt/mailer/bin:$PATH

# Default port
EXPOSE 4047
CMD ["mailer"]

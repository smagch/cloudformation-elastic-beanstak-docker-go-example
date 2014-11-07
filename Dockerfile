FROM golang:1.3.3

RUN mkdir -p /go/src/app
WORKDIR /go/src/app
COPY . /go/src/app

EXPOSE 8080
RUN ["go", "install", "."]
RUN ["app"]

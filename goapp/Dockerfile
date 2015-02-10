FROM golang:1.3.3

RUN mkdir -p /go/src/app
WORKDIR /go/src/app
COPY . /go/src/app

ENV GOPATH /go/src/app/Godeps/_workspace:$GOPATH
ENV PATH /go/src/app/Godeps/_workspace/bin:$PATH

EXPOSE 8080
RUN ["go", "install", "."]
CMD ["./bin/start.sh"]

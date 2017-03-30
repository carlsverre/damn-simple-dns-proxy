FROM golang:1.8-alpine
RUN apk update && apk upgrade && apk add --no-cache git

ADD . /go/src/github.com/carlsverre/damn-simple-dns-proxy
RUN go get -d -v github.com/carlsverre/damn-simple-dns-proxy
RUN go build -v -o /dsdp github.com/carlsverre/damn-simple-dns-proxy

EXPOSE 53/udp
CMD ["/dsdp"]

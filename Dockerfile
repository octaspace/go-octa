FROM golang:1.18-alpine as builder

RUN apk add --no-cache gcc musl-dev linux-headers git

ADD . /geth
RUN cd /geth && go run build/ci.go install ./cmd/geth
RUN strip /geth/build/bin/geth

FROM alpine:latest

RUN apk add --no-cache ca-certificates
COPY --from=builder /geth/build/bin/geth /usr/local/bin/

EXPOSE 8545 8546 38000 38000/udp
ENTRYPOINT ["geth"]

FROM golang:alpine3.7 as builder

WORKDIR /root

RUN apk update && \
	apk add --no-cache --virtual .build-deps \
		gcc \
		g++ \
		git \
	; \
	go get -d \
		github.com/dgrijalva/jwt-go \
		github.com/dgryski/dgoogauth \
		github.com/mattn/go-sqlite3 \
		github.com/satori/go.uuid \
		github.com/VictorNine/bitwarden-go \
		golang.org/x/crypto \
		# ignore "no Go files in ..." error
		|| : \
	; \
	go build github.com/VictorNine/bitwarden-go/cmd/bitwarden-go


FROM alpine:latest

ENV VAULT_URL http://localhost:4001

WORKDIR /root

COPY --from=builder /root/bitwarden-go .

RUN mkdir /data

VOLUME /data

EXPOSE 8000

CMD /root/bitwarden-go -init -location /data -vaultURL ${VAULT_URL}

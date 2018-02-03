FROM golang:alpine

ENV VAULT_URL http://localhost:4001

RUN apk update && \
	apk add --no-cache --virtual .build-deps \
		gcc	\
		g++ \
		git	\
	; \
	go get \
		github.com/dgrijalva/jwt-go \
		github.com/dgryski/dgoogauth \
		github.com/mattn/go-sqlite3 \
		github.com/satori/go.uuid \
		github.com/VictorNine/bitwarden-go \
		golang.org/x/crypto \
	; \
	go install github.com/VictorNine/bitwarden-go/cmd/bitwarden-go \
	; \
	apk del .build-deps \
	; \
	rm -rf /go/src \
	; \
	mkdir /data

VOLUME /data

EXPOSE 8000

CMD bitwarden-go -init -location /data -vaultURL ${VAULT_URL}

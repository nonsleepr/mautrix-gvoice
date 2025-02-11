FROM golang:1-alpine3.20 AS builder

RUN apk add --no-cache git ca-certificates build-base su-exec olm-dev

COPY . /build
WORKDIR /build
RUN go build -o /usr/bin/mautrix-gvoice ./cmd/mautrix-gvoice

FROM node:20-alpine AS runtime

RUN apk add --no-cache ffmpeg su-exec ca-certificates olm bash jq yq-go curl \
    udev ttf-freefont chromium

ENV UID=1337 \
    GID=1337 \
    PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser \
    NODE_PATH=/usr/local/lib/node_modules

COPY --from=builder /usr/bin/mautrix-gvoice /usr/bin/mautrix-gvoice
COPY --from=builder /build/docker-run.sh /docker-run.sh
VOLUME /data

RUN npm install -g puppeteer
RUN addgroup -g $GID -S user && adduser -u $UID -S -G user user \
    && chown -R $GID:$UID /home/user

CMD ["/docker-run.sh"]

FROM elixir:1.12.2-alpine as builder

RUN apk add --no-cache \
  git

ENV MIX_ENV=dev

WORKDIR /app

COPY mix.*  ./

RUN mix local.rebar --force && \
  mix local.hex --if-missing --force && \
  mix do deps.get, deps.compile

COPY . .

RUN mix escript.build \
  && rm -rf /app/deps

#########################
# Stage: production     #
#########################

FROM alpine:3.11 as production

RUN apk add --no-cache \
  bash \
  openssl \
  curl

WORKDIR /app

ENV MIX_ENV=dev

COPY --from=builder /app/ ./

RUN chown -R nobody: /app
USER nobody
ENV HOME=/app

ENTRYPOINT ["ex_mars"]
# CMD ["./bin/start.sh"]

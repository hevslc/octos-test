FROM elixir:1.18.0-alpine

RUN mkdir /octos
WORKDIR /octos
COPY . /octos

RUN mix local.hex --force && \
    mix local.rebar --force

RUN echo "[OCTOS] - GETTING DEPS"
RUN mix deps.get && mix deps.compile

COPY docker_dev_start.sh /octos/
RUN chmod +x /octos/docker_dev_start.sh
FROM elixir:1.9.0-alpine

LABEL application="promo"


ENV TERM=xterm-256color

# Set the locale
ENV LANG="en_US.utf8"
ENV LANGUAGE="en_US:"

ENV HOME=/opt/app
WORKDIR $HOME


RUN apk update
RUN apk add  bash curl nodejs npm inotify-tools postgresql-client



#install phoenix dependenices
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix archive.install --force hex phx_new 1.4.3


COPY . .


RUN mix deps.get


EXPOSE 4000
RUN chmod +x ./entry.sh
ENTRYPOINT [ "./entry.sh" ]
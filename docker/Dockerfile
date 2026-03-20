FROM ubuntu:24.04
WORKDIR /app

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get -y install tzdata
RUN apt-get -y install zip unzip wget git build-essential cmake curl libcurl4t64 libgmp-dev libssl-dev libusb-1.0-0-dev libzstd-dev time pkg-config libfaketime

COPY ./node /app/node
COPY ./scripts /app/scripts
COPY ./entrypoint.sh /app/

# anvo-core packages must be placed in docker/packages/ before building.
# They will be available from the AnvoIO/anvo-core releases.
COPY ./packages /app/packages
RUN ./scripts/bootstrap_env.sh

RUN cd /app && chmod +x *.sh

ENV ANVO_PUB_KEY=EOS5dUsCQCAyHVjnqr6BFqVEE7w8XksnkRtz22wd9eFrSq4NHoKEH
ENV ANVO_PRV_KEY=5JKxAqBoQuAYSh6YMcjxcougPpt1pi9L4PyJHwEQuZgYYgkWpjS

EXPOSE 8888

HEALTHCHECK --start-period=100ms --interval=500ms --timeout=500ms --retries=20\
  CMD ./scripts/health_check.sh || exit 1

ENTRYPOINT ["./entrypoint.sh"]

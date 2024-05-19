FROM debian:11-slim

ARG NEZHA_VER
ENV domain="" port="5555" secret="" args="--disable-auto-update" platform="" version=""

WORKDIR /usr/local/bin

COPY ./entrypoint.sh /usr/local/bin/

RUN apt-get update &&\
    apt-get install -y --no-install-recommends tini wget unzip ca-certificates gawk &&\
    rm -rf /var/lib/apt/lists/* &&\
    arch=$(uname -m | sed "s#x86_64#amd64#; s#aarch64#arm64#; s#i386#386#") &&\
    NEZHA_VER=$(wget -qO- https://api.github.com/repos/nezhahq/agent/tags | gawk -F '["v]' '/name/{print "v"$5;exit}') &&\
    wget -O ./nezha-agent.zip -t 4 -T 5 "https://github.com/nezhahq/agent/releases/download/${NEZHA_VER}/nezha-agent_linux_${arch}.zip"&&\
    unzip ./nezha-agent.zip &&\
    rm -f ./nezha-agent.zip &&\
    chmod +x ./entrypoint.sh &&\
    chmod +x ./nezha-agent

ENTRYPOINT ["/usr/bin/tini","-g","--","/usr/local/bin/entrypoint.sh"]

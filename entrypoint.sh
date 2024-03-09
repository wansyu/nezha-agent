#!/bin/bash

#check domain and secret variables
if [[ -z "${domain}" || -z "${secret}" ]]; then
    echo "Domain and secret cannot be empty!"
    exit 1
fi

#modify platform
if [ -n "${platform}" ] || [ -n "${version}" ]; then
    rm -f /etc/debian_version
    if [ -n "${platform}" ]; then
        sed -i "s/^ID=.*/ID=${platform}/" /etc/os-release
    fi

    if [ -n "${version}" ]; then
        sed -i "s/^VERSION=.*/VERSION=${version}/" /etc/os-release
    fi
fi
if [[ -z "${proxy}" ]]; then
    # echo "proxy is empty!"
    exec /usr/local/bin/gg --node ${proxy} /usr/local/bin/nezha-agent -s ${domain}:${port} -p ${secret} ${args}
else
    echo "proxy is used!"
    exec /usr/local/bin/nezha-agent -s ${domain}:${port} -p ${secret} ${args}
fi

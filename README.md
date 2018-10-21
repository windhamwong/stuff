# My Own Scripts

quick install command:

    curl https://raw.githubusercontent.com/windhamwong/stuff/master/auto.sh |bash -s

quick docker command:

    curl https://raw.githubusercontent.com/windhamwong/stuff/master/dockerCmd.sh |bash -s

Building Heron Docker with librdkafka installed:

    docker rm -f build
    docker run -it --name build \
    -v /opt/heron/root/:/heron/ \
    --network docker heron/heron:latest \
    /bin/bash -c "apt-get update && \
        apt-get install build-essential gcc python-dev software-properties-common -y && \
        add-apt-repository 'deb http://deb.debian.org/debian stretch-backports main contrib non-free' && \
        apt-get update && \
        cd /tmp && curl https://codeload.github.com/edenhill/librdkafka/tar.gz/v0.11.6 |tar -xvz && \
        cd /tmp/librdkafka-0.11.?/ && \
        ./configure && make && make install && \
        ln -s /usr/local/lib/librdkafka.so.1 /usr/lib/x86_64-linux-gnu/librdkafka.so.1 \
        bash /heron/heron-install.sh"
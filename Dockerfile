from python:3.8
run python3 -m pip install \
    --no-cache-dir  -U \
    devpi-server==5.3.1 \
    devpi-web==4.0.1 \
    devpi-client==5.1.1 \
    && rm -rf /root/.cache
add /devpi/bin/* /usr/bin/
cmd ["/usr/bin/devpi-start"]
expose 3141
env DEBUG=0 \
    DEVPISERVER_SERVERDIR=/devpi/serverdir \
    DEVPISERVER_PORT=3141 \
    DEVPISERVER_HOST=0.0.0.0

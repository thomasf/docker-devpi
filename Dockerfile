from python:3.9 as builder
copy requirements*.txt  /requirements/
run pip wheel \
    --wheel-dir /wheel \
    --no-cache-dir \
    -r /requirements/requirements.txt \
    -r /requirements/requirements-plugins.txt

from python:3.9
copy requirements*.txt  /requirements/
copy --from=builder /wheel /wheel
run python3 -m pip install \
    --no-cache-dir \
    --upgrade \
    --find-links /wheel \
    --no-index \
    devpi-server \
    devpi-web \
    devpi-client \
    && rm -rf /root/.cache
add /devpi/bin/* /usr/bin/
cmd ["/usr/bin/devpi-start"]
expose 3141
env DEBUG=0 \
    DEVPISERVER_SERVERDIR=/devpi/serverdir \
    DEVPISERVER_PORT=3141 \
    DEVPISERVER_HOST=0.0.0.0 \
    DEVPI_PLUGINS=0

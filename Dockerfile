FROM python:3.13.0-alpine3.20

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY . /app

WORKDIR /app

ARG DEV=false
RUN <<EOF
    python -m venv /py
    /py/bin/pip install --upgrade pip
    apk add --update --no-cache postgresql-client
    apk add --update --no-cache --virtual .build-deps build-base postgresql-dev musl-dev
    /py/bin/pip install -r /tmp/requirements.txt
    if [ $DEV = "true" ]; then
        /py/bin/pip install -r /tmp/requirements.dev.txt
        apk add --update --no-cache git
    fi
    rm -rf /tmp
    apk del .build-deps
EOF

ENV PATH="/py/bin:$PATH"
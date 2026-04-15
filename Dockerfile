FROM python:3.9-alpine3.13

LABEL maintainer="prakash"

ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Copy requirements first (better caching)
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements-dev.txt /tmp/requirements-dev.txt

# Install runtime dependencies
RUN apk add --no-cache \
    libpq \
    libffi

ARG DEV=false

# Install build dependencies, install Python deps, then clean up
RUN apk add --no-cache --virtual .build-deps \
        gcc \
        musl-dev \
        libffi-dev \
        postgresql-dev \
        linux-headers && \
    python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ "$DEV" = "true" ]; then \
        /py/bin/pip install -r /tmp/requirements-dev.txt; \
    fi && \
    rm -rf /tmp && \
    apk del .build-deps

# Copy project files
COPY ./app /app

# Add non-root user
RUN adduser -D django-user
USER django-user

# Set PATH
ENV PATH="/py/bin:$PATH"

EXPOSE 8000

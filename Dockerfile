FROM python:3.9-alpine3.13

LABEL maintainer="prakash"

ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Copy requirements first (better caching)
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements-dev.txt /tmp/requirements-dev.txt

# Install system dependencies
RUN apk add --no-cache \
        gcc \
        musl-dev \
        libffi-dev \
        postgresql-dev

# Add build argument for dev mode
ARG DEV=false

# Create virtual environment and install dependencies
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ "$DEV" = "true" ]; then \
        /py/bin/pip install -r /tmp/requirements-dev.txt; \
    fi && \
    rm -rf /tmp

# Copy project files
COPY ./app /app

# Set PATH
ENV PATH="/py/bin:$PATH"

# Create non-root user
RUN adduser -D django-user
USER django-user

EXPOSE 8000

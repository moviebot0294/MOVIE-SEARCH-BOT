# Dockerfile - updated (python 3.11 on slim-bookworm)
FROM python:3.11-slim-bookworm

LABEL maintainer="you@example.com"
ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

# Install system deps for building common wheels
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
      build-essential \
      gcc \
      git \
      libssl-dev \
      libffi-dev \
      libxml2-dev \
      libxslt1-dev \
      zlib1g-dev \
      curl \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy only requirements first to use docker cache
COPY requirements.txt /app/requirements.txt

RUN python -m pip install --upgrade pip \
  && pip install --no-cache-dir -r /app/requirements.txt

COPY . /app

# Create non-root user, set permissions
RUN useradd --create-home botuser \
  && chown -R botuser:botuser /app

USER botuser
ENV PATH="/home/botuser/.local/bin:${PATH}"

CMD ["python", "bot.py"]


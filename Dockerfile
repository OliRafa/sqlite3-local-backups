# Base Image
FROM python:3.12-slim AS python-base

ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV PIP_NO_CACHE_DIR=1
ENV PIP_DISABLE_PIP_VERSION_CHECK=on
ENV PIP_DEFAULT_TIMEOUT=100
ENV POETRY_VERSION=1.8.2
ENV POETRY_HOME="/opt/poetry"
ENV POETRY_NO_INTERACTION=1
ENV POETRY_VIRTUALENVS_CREATE=false
ENV VIRTUAL_ENV="/venv"

ENV PATH="$POETRY_HOME/bin:$VIRTUAL_ENV/bin:$PATH"

RUN python -m venv $VIRTUAL_ENV

WORKDIR /app

# Builder Image
FROM python-base AS builder-base

RUN apt-get update && \
    apt-get install -y \
    apt-transport-https \
    gnupg \
    ca-certificates \
    build-essential \
    git \
    nano \
    curl \
    && apt-get clean

# Install go-cron
ARG GOCRONVER=v0.0.11
ARG TARGETOS=linux
ARG TARGETARCH=amd64

RUN set -x \
	&& curl --fail --retry 4 --retry-all-errors -o /usr/local/bin/go-cron.gz -L https://github.com/prodrigestivill/go-cron/releases/download/$GOCRONVER/go-cron-$TARGETOS-$TARGETARCH.gz \
	&& gzip -vnd /usr/local/bin/go-cron.gz \
    && chmod a+x /usr/local/bin/go-cron

# install poetry - respects $POETRY_VERSION & $POETRY_HOME
# The --mount will mount the buildx cache directory to where
# Poetry and Pip store their cache so that they can re-use it
RUN --mount=type=cache,target=/root/.cache \
    curl -sSL https://install.python-poetry.org | python -


WORKDIR /app

COPY poetry.lock pyproject.toml README.md ./
COPY src ./src/
RUN --mount=type=cache,target=/root/.cache \
    poetry install --without dev

# Production Image
FROM python-base AS production

ENV BACKUPS_FOLDER_PATH="/backups"
ENV BACKUP_KEEP_DAYS=7
ENV BACKUP_KEEP_WEEKS=4
ENV BACKUP_KEEP_MONTHS=6
ENV DATABASE_PATH=""
ENV HEALTHCHECK_PORT=8080
ENV SCHEDULE="@daily"

COPY --from=builder-base /usr/local/bin/go-cron /usr/local/bin/go-cron
COPY --from=builder-base $VIRTUAL_ENV $VIRTUAL_ENV
COPY --from=builder-base /app /app

COPY entrypoint.sh /

CMD /entrypoint.sh $DATABASE_PATH $BACKUPS_FOLDER_PATH

HEALTHCHECK --interval=5m --timeout=3s \
  CMD curl -f "http://localhost:$HEALTHCHECK_PORT/" || exit 1
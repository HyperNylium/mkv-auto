FROM ubuntu:24.04

WORKDIR /pre
COPY prerequisites.sh /pre/
COPY requirements.txt /pre/
RUN ./prerequisites.sh

# Install gosu for user switching
RUN apt-get update && apt-get install -y gosu && rm -rf /var/lib/apt/lists/*

WORKDIR /mkv-auto
COPY modules /mkv-auto/modules
COPY utilities /mkv-auto/utilities
COPY defaults.ini /mkv-auto/
COPY subliminal_defaults.toml /mkv-auto/
COPY mkv-auto.py /mkv-auto/
COPY entrypoint.sh /mkv-auto/
COPY service-entrypoint.sh /mkv-auto/
COPY service-entrypoint-inner.sh /mkv-auto/
RUN chmod +x /mkv-auto/*.sh
RUN mkdir -p /mkv-auto/files/.cache

# Use root so we can dynamically create user at runtime
USER root

ENTRYPOINT ["/mkv-auto/entrypoint.sh"]

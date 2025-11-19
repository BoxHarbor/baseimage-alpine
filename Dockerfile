# BoxHarbor Base Image - Alpine
# Lightweight, rootless-compatible base image
FROM docker.io/library/alpine:3.22

# Build arguments
ARG BUILD_DATE
ARG VERSION
ARG VCS_REF

# Labels (OCI standard)
LABEL org.opencontainers.image.created="${BUILD_DATE}" \
  org.opencontainers.image.title="BoxHarbor Base Image - Alpine" \
  org.opencontainers.image.description="Lightweight base image for containerized applications" \
  org.opencontainers.image.url="https://github.com/BoxHarbor/baseimage-alpine" \
  org.opencontainers.image.source="https://github.com/BoxHarbor/baseimage-alpine" \
  org.opencontainers.image.version="${VERSION}" \
  org.opencontainers.image.revision="${VCS_REF}" \
  org.opencontainers.image.vendor="BoxHarbor" \
  org.opencontainers.image.licenses="GPL-3.0" \
  maintainer="BoxHarbor Team"

# Environment variables
ENV PUID=1000 \
  PGID=1000 \
  TZ=UTC \
  UMASK=022 \
  HOME=/config

# Install base packages
RUN apk add --no-cache \
  bash \
  ca-certificates \
  coreutils \
  curl \
  shadow \
  su-exec \
  tini \
  tzdata \
  && rm -rf /var/cache/apk/* /tmp/*

# Create directory structure
RUN mkdir -p \
  /app \
  /config \
  /defaults \
  /etc/cont-init.d \
  /etc/services.d

# Create non-root user and group
RUN addgroup -g 1000 appuser && \
  adduser -D -u 1000 -G appuser -h /config -s /bin/bash appuser

# Copy rootfs
COPY rootfs/ /

# Set execute permissions
RUN chmod +x /init && \
  find /etc/cont-init.d -type f -exec chmod +x {} \; && \
  find /etc/services.d -name run -type f -exec chmod +x {} \;

# Set ownership (will be remapped in rootless mode)
RUN chown -R appuser:appuser \
  /app \
  /config \
  /defaults

# Persistent volume
VOLUME ["/config"]

# Working directory
WORKDIR /app

# Health check (override in derived images)
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD true

# Use tini as init system
ENTRYPOINT ["/sbin/tini", "--", "/init"]

# Default command (override in derived images)
CMD []
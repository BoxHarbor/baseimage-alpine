# BoxHarbor Base Image - Alpine

[![Docker Pulls](https://img.shields.io/docker/pulls/gaetanddr/baseimage-alpine)](https://hub.docker.com/r/gaetanddr/baseimage-alpine)
[![GitHub](https://img.shields.io/github/license/boxharbor/baseimage-alpine)](https://github.com/BoxHarbor/baseimage-alpine)

A lightweight, rootless-compatible base image built on Alpine Linux with tini process manager. Designed for building containerized applications that work seamlessly with both Docker and Podman in rootless mode.

## Features

- 🪶 **Lightweight**: Based on Alpine Linux
- 🔒 **Rootless Compatible**: Works with Podman and Docker rootless mode
- 🎯 **Simple Init System**: Uses tini for proper signal handling
- 📁 **Standardized Structure**: `/config` for persistent data
- 🔧 **Customizable**: Easy-to-extend with init and service scripts
- 🌍 **Multi-arch**: Supports amd64, arm64, armv7

## Quick Start

This is a base image meant to be used as a foundation for other images.

```dockerfile
FROM ghcr.io/boxharbor/baseimage-alpine:latest

# Install your application
RUN apk add --no-cache your-package

# Add your service script
COPY rootfs/ /

# Expose ports
EXPOSE 8080
```

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `PUID` | `1000` | User ID for file permissions |
| `PGID` | `1000` | Group ID for file permissions |
| `TZ` | `UTC` | Timezone |
| `UMASK` | `022` | File creation mask |

## Directory Structure

```
/app        - Application files
/config     - Persistent configuration (mount this!)
/defaults   - Default configuration templates
```

## Extending the Base Image

### Adding Init Scripts

Create scripts in `/etc/cont-init.d/` that run during container startup:

```bash
#!/bin/bash
# /etc/cont-init.d/20-my-init

echo "Running custom initialization..."
# Your setup logic here
```

Scripts are executed in alphanumeric order (10-, 20-, 30-, etc.).

### Adding Services

Create service directories in `/etc/services.d/`:

```bash
#!/bin/bash
# /etc/services.d/myapp/run

cd /app
exec /app/myapp-binary
```

Services run as background processes managed by the init system.

## Usage Examples

### With Docker

```bash
docker run -d \
  --name myapp \
  -v ./config:/config \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  your-app:latest
```

### With Podman (Rootless)

```bash
podman run -d \
  --name myapp \
  -v ./config:/config:Z \
  -e PUID=1000 \
  -e PGID=1000 \
  your-app:latest
```

**Note**: Use `:Z` suffix for SELinux systems (Fedora, RHEL, CentOS).

## Building from Source

```bash
git clone https://github.com/BoxHarbor/baseimage-alpine.git
cd baseimage-alpine
docker build -t boxharbor/baseimage-alpine:latest .
```

## Contributing

Contributions are welcome! Please read our [Contributing Guidelines](CONTRIBUTING.md) before submitting PRs.

## License

GPL-3.0 License - see [LICENSE](LICENSE) file for details.

## Support

- 💬 GitHub Issues: [Report bugs or request features](https://github.com/BoxHarbor/baseimage-alpine/issues)
- 📖 Documentation: [Full documentation](https://github.com/BoxHarbor/baseimage-alpine/wiki)

---

Built with ❤️ by the BoxHarbor team

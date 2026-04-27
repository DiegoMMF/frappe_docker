# Frappe Docker

![Frappe Docker](docs/public/frappe-docker.png)

Docker images and orchestration for Frappe applications.

[![Build Stable](https://img.shields.io/github/actions/workflow/status/frappe/frappe_docker/core-build-stable.yml?branch=main&label=Build%20Stable)](https://github.com/frappe/frappe_docker/actions/workflows/core-build-stable.yml)
[![Build Develop](https://img.shields.io/github/actions/workflow/status/frappe/frappe_docker/core-build-develop.yml?branch=main&label=Build%20Develop)](https://github.com/frappe/frappe_docker/actions/workflows/core-build-develop.yml)
[![Docs](https://img.shields.io/badge/Docs-Open%20Site-0A7EA4)](https://frappe.github.io/frappe_docker/)

## What is this?

This repository is the official container setup for Frappe applications.

It provides Docker images, Compose configurations, and documentation for running Frappe applications, including ERPNext, CRM, Helpdesk, and other Frappe apps, in containers.

Use it if you want to:

- run ERPNext, CRM, Helpdesk, or other Frappe apps with Docker
- start from a quick demo setup
- use production-ready Docker images and Compose setups
- build custom app images
- deploy and operate Frappe in production

## Repository Structure

```bash
frappe_docker/
├── docs/                 # Complete documentation
├── overrides/            # Docker Compose configurations for different scenarios
├── compose.yaml          # Base Compose File for production setups
├── pwd.yml               # Single Compose File for quick disposable demo
├── images/               # Dockerfiles for building Frappe images
├── development/          # Development environment configurations
├── devcontainer-example/ # VS Code devcontainer setup
└── resources/            # Helper scripts and configuration templates
```

> This section describes the structure of **this repository**, not the Frappe framework itself.

### Key Components

- `docs/` - Canonical documentation for all deployment and operational workflows
- `overrides/` - Opinionated Compose overrides for common deployment patterns
- `compose.yaml` - Base compose file for production setups (production)
- `pwd.yml` - Disposable demo environment (non-production)

## Documentation

The full `frappe_docker` documentation is available in [`docs/`](docs/) and published at [frappe.github.io/frappe_docker](https://frappe.github.io/frappe_docker/).

### Recommended entry points

- **New here:** [Getting Started Guide](docs/getting-started.md)
- **Choosing a setup:** [Deployment methods](docs/01-getting-started/01-choosing-a-deployment-method.md)
- **ARM64 notes:** [ARM64](docs/01-getting-started/03-arm64.md)
- **Container setup overview:** [Container Setup Overview](docs/02-setup/01-overview.md)
- **Running in production:** [Production docs](docs/03-production/)
- **Operating a deployment:** [Operations docs](docs/04-operations/)
- **Development workflows:** [Development](docs/05-development/01-development.md)
- **FAQ:** [Frequently Asked Questions](https://github.com/frappe/frappe_docker/wiki/Frequently-Asked-Questions)

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose v2](https://docs.docker.com/compose/)
- [git](https://docs.github.com/en/get-started/getting-started-with-git/set-up-git)

> For Docker basics and best practices refer to Docker's [documentation](http://docs.docker.com)

## Demo setup

The fastest way to try Frappe locally is with the single-file demo setup in `pwd.yml`.

### Try on your environment

> **⚠️ Disposable demo only**
>
> **This setup is intended for short-lived evaluation only.** You will not be able to install custom apps to this setup. For production deployments, custom configurations, and detailed explanations, see the full documentation.

First clone the repo:

```sh
git clone https://github.com/frappe/frappe_docker
cd frappe_docker
```

Then run:

```sh
docker compose -f pwd.yml up -d
```

Wait for a couple of minutes for ERPNext site to be created or check `create-site` container logs before opening browser on port `8080`. (username: `Administrator`, password: `admin`)

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## Versioning and Releases

This fork uses SemVer tags (`vX.Y.Z`) for releases cut from `deploy/gemar-v16`.

- `VERSION` — current version number
- `CHANGELOG.md` — tracks all changes ([Keep a Changelog](https://keepachangelog.com/))
- `scripts/bump-version.sh` — bumps VERSION and promotes Unreleased in CHANGELOG

Release flow: `bump-version.sh X.Y.Z` → commit → tag `vX.Y.Z` → push → CI builds + publishes.

This repository is only for container related stuff. You also might want to contribute to:

## Resources

- [Frappe framework](https://github.com/frappe/frappe),
- [ERPNext](https://github.com/frappe/erpnext),
- [Frappe Bench](https://github.com/frappe/bench).

## License

This repository is licensed under the MIT License. See [LICENSE](LICENSE) for details.

# EscapeCloud Platform - Helm

Deploying EscapeCloud Platform via Helm is intended to be simple. This folder contains the chart metadata, chart templates, a sample values file, and this README.

Project structure:

```text
.
├── Chart.yaml
├── values.sample.yaml
├── templates/
└── README.md
```

## Overview

The Helm chart deploys the main Escape components:

- `escape_webapp`
- `escape_scheduler`
- `escape_api`
- `escape_engine_stage1` to `escape_engine_stage9`
- `escape-engine-init`
- `escape-masterdata-init`

The chart expects external infrastructure for:

- PostgreSQL
- RabbitMQ

If you are using customer-managed infrastructure for PostgreSQL or RabbitMQ, provide the connection details in your `values.yaml`.

## Responsibilities

The Helm chart is responsible for:

- Deploying application workloads
- Creating internal Kubernetes `Service` resources
- Running one-time bootstrap jobs
- Running scheduled CronJobs

The customer or platform team is responsible for:

- Kubernetes cluster lifecycle
- PostgreSQL
- RabbitMQ
- Registry access credentials
- DNS
- Gateway / Ingress
- TLS certificates and renewal

## Prerequisites

Before deployment, make sure you have:

- Kubernetes cluster access
- Helm installed
- Access to `registry.onstackit.cloud`
- External PostgreSQL ready
- External RabbitMQ ready
- A Kubernetes namespace for the deployment

If you plan to expose the application publicly, you also need:

- DNS pointing your hostname to your Gateway / Ingress
- Gateway / Ingress configured separately
- TLS configured separately if required

## Configuration

Copy `values.sample.yaml` to your own `values.yaml`:

```bash
cp values.sample.yaml values.yaml
```

Then fill in the required values.

Important values:

- `global.hostName`
  Public hostname, for example `domain.tld`
- `global.imagePullSecrets`
  Image pull secret for `registry.onstackit.cloud`
- `escapeWeb.image.repository`
  Web image repository
- `escapeWeb.image.tag`
  Web image tag to deploy
- `escapeWeb.env.WEB_DB_*`
  Web database connection settings
- `escapeWeb.secretEnv.*`
  Web application secrets
- `escapeEngine.image.repository`
  Engine image repository
- `escapeEngine.image.tag`
  Engine image tag to deploy
- `escapeEngine.env.ENGINE_DB_*`
  Engine database connection settings
- `escapeEngine.env.RABBITMQ_*`
  RabbitMQ connection settings
- `escapeEngine.secretEnv.*`
  Engine application secrets

## Install

Create the namespace if needed:

```bash
kubectl create namespace escape
```

Install or upgrade the chart:

```bash
helm upgrade --install escape . -n escape -f values.yaml
```

If you want Helm to create the namespace automatically:

```bash
helm upgrade --install escape . -n escape --create-namespace -f values.yaml
```

## Verify

Check that workloads are created:

```bash
kubectl get all -n escape
kubectl get jobs,cronjobs -n escape
```

Important checks:

- `escape-engine-init` completed successfully
- `escape-masterdata-init` completed successfully
- `escape-webapp` is ready
- `escape-api` is ready
- `escape_engine_stage1` to `escape_engine_stage9` are running

Useful commands:

```bash
kubectl logs job/escape-engine-init -n escape
kubectl logs job/escape-masterdata-init -n escape
kubectl logs deploy/escape-webapp -n escape
kubectl logs deploy/escape-api -n escape
```

## Networking

The chart creates only internal Kubernetes `Service` resources.

External exposure is handled separately through your Gateway or Ingress layer.

## Upgrade

Update the image tags in `values.yaml`, then run:

```bash
helm upgrade --install escape . -n escape -f values.yaml
```

For example:

- update `escapeWeb.image.tag` for a web-only release
- update `escapeEngine.image.tag` for an engine-only release
- update both for a coordinated release

## Troubleshooting

If image pulls fail:

- verify `imagePullSecrets`
- verify registry credentials

If bootstrap jobs fail:

- inspect `escape-engine-init` logs
- inspect `escape-masterdata-init` logs
- verify PostgreSQL and RabbitMQ connectivity

If web or API pods are not ready:

- inspect deployment logs
- verify database connectivity
- verify required secrets are present

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.0.1] - 2025-01-12

### Added

- Initial project setup with Turborepo monorepo structure
- Next.js web application with TypeScript and Tailwind CSS
- Express.js API server with tRPC integration
- Shared API package for type-safe client-server communication
- Comprehensive observability stack:
  - OpenTelemetry instrumentation for distributed tracing
  - Prometheus metrics collection
  - Grafana dashboards for monitoring
  - Sentry error tracking and performance monitoring
- Docker-based infrastructure setup with development and production configurations
- GitHub Actions CI/CD pipeline with automated testing and building
- ESLint and Prettier configuration for code quality
- Jest testing framework with SWC for fast compilation
- Infrastructure management scripts for easy development workflow
- VS Code settings for consistent development experience

### Infrastructure

- Docker Compose setup for local development
- Prometheus and Grafana monitoring stack
- OpenTelemetry Collector for telemetry data processing
- Sentry integration for error tracking
- Production-ready Docker configurations

### Developer Experience

- Hot reloading for all applications
- Automated code formatting and linting
- Pre-commit hooks with lint-staged
- Comprehensive testing setup
- Infrastructure management CLI tools

<!-- markdownlint-disable MD033 -->
<!-- markdownlint-disable MD041 -->

<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->

[![taskfile][taskfile-shield]][taskfile-url]
[![pre-commit][pre-commit-shield]][pre-commit-url]

# I see dead Pods

Get rid of `Pod was terminated in response to imminent node shutdown.` Pods forever.

<details>
  <summary style="font-size:1.2em;">Table of Contents</summary>

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Story](#story)
- [Setup](#setup)
  - [kubectl](#kubectl)
  - [flux](#flux)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->
</details>

## Story

In Kubernetes, pods can remain in a broken state for a long time if graceful shutdown is enabled. This state results in an alert from kube-prometheus-stack.

```console
[FIRING:1] Pod has been in a non-ready state for more than 15 minutes.
Severity:  warning
Description: Pod default/some-container-7fb4c4fbc5-gbjwm has been in a non-ready state for longer than 15 minutes.
Details:
  • alertname: KubePodNotReady
  • namespace: default
  • pod: some-container-7fb4c4fbc5-gbjwm
  • prometheus: observability/kube-prometheus-stack-prometheus
  • severity: warning
```

Many solutions on the internet delete all Pods in `Error` or `Terminated` state without control. I consider this a bad idea, because you then no longer see whether real `Error` Pods exist in your cluster.

These manifests provide a Kubernetes `CronJob`. The `CronJob` deletes all Pods that match the given criteria.

## Setup

The `CronJob` deletes Pods in all namespaces and needs cluster-wide delete permission. All resources use the `kube-system` namespace.

### kubectl

Apply the raw manifests:

```console
kubectl apply -f https://raw.githubusercontent.com/tyriis/i-see-dead-pods/main/manifests/raw/service-account.yaml
kubectl apply -f https://raw.githubusercontent.com/tyriis/i-see-dead-pods/main/manifests/raw/rbac.yaml
kubectl apply -f https://raw.githubusercontent.com/tyriis/i-see-dead-pods/main/manifests/raw/cronjob.yaml
```

Or apply a local clone:

```console
kubectl apply -f manifests/raw/
```

The manifests set the `kube-system` namespace. Do not pass `-n` with a different namespace. A mismatch causes an error.

### flux

Apply the HelmRelease:

```console
kubectl apply -f https://raw.githubusercontent.com/tyriis/i-see-dead-pods/main/manifests/flux/helm-release.yaml
```

The HelmRelease is a Kubernetes object, so `kubectl apply` creates it. It takes effect only when a helm-controller (Flux) reconciles it. Flux then renders the [bjw-s app-template](https://github.com/bjw-s-labs/helm-charts) chart.

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->

<!-- Links -->

<!-- Badges -->

[taskfile-shield]: https://img.shields.io/badge/Taskfile-enabled-brightgreen?logo=task
[taskfile-url]: https://taskfile.dev/
[pre-commit-shield]: https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit
[pre-commit-url]: https://github.com/pre-commit/pre-commit

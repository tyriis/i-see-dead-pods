<!-- markdownlint-disable MD041 -->
<!-- markdownlint-disable MD033 -->
<!-- markdownlint-disable MD051 -->

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
  - [kustomize](#kustomize)
  - [flux helmrelease](#flux-helmrelease)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->
</details>

## Story

In Kubernetes, pods can remain in a broken state for a long time if graceful shutdown is enabled. This state results in an alert getting fired by kube-prometheus-stack.

```console
[FIRING:1] Pod has been in a non-ready state for more than 15 minutes.
Severity:  warning
Description: Pod default/some-container-7fb4c4fbc5-gbjwm has been in a non-ready state for longer than 15 minutes.
Details:
  • alertname: KubePodNotReady \
  • namespace: default \
  • pod: some-container-7fb4c4fbc5-gbjwm \
  • prometheus: observability/kube-prometheus-stack-prometheus \
  • severity: warning
```

Most of the `solutions` on the internet describe an uncontrolled deletion of all Pods in `Error` or `Terminated` state.
Wich I consider as a bad idea, because you will not see anymore if real `Error` Pods are in your system.

These manifests provide a kubernetes `CronJob` deleting constantly all Pods with given criterias.

## Setup

### kubectl

You can apply the manifests manually:

```console
kubectl apply -f https://raw.githubusercontent.com/tyriis/i-see-dead-pods/main/manifests/service-account.yaml
kubectl apply -f https://raw.githubusercontent.com/tyriis/i-see-dead-pods/main/manifests/rbac.yaml
kubectl apply -f https://raw.githubusercontent.com/tyriis/i-see-dead-pods/main/manifests/cronjob.yaml
```

### kustomize

or with kustomize

### flux helmrelease

or with flux, see [helmrelease](./manifests/flux-helmrelease.yaml).

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->

<!-- Links -->

<!-- Badges -->

[taskfile-shield]: https://img.shields.io/badge/Taskfile-enabled-brightgreen?logo=task
[taskfile-url]: https://taskfile.dev/
[pre-commit-shield]: https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit
[pre-commit-url]: https://github.com/pre-commit/pre-commit

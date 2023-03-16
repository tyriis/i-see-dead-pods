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

In kubernetes with gracefull shutdown enabled, pods can stay for long time perriods in a `broken` state. The state results in alerting getting fired by kube-prometheus-stack.

```console
[FIRING:1] Pod has been in a non-ready state for more than 15 minutes.
Severity:  warning
 Description: Pod default/some-container-7fb4c4fbc5-gbjwm has been in a non-ready state for longer than 15 minutes.
 Details:
  • alertname: KubePodNotReady • namespace: default • pod: some-container-7fb4c4fbc5-gbjwm • prometheus: observability/kube-prometheus-stack-prometheus • severity: warning
```

Most of the `solutions` on the internet describe an uncontrolled deletion of all Pods in `Error` or `Terminated` state.
Wich I consider as a bad idea, because you will not see anymore if real `Error` Pods are in your system.

These manifests provide a kubernetes `CronJob` deleting constantly all Pods with given criterias.

## Setup

### kubectl

You can apply the manifests manually:

```console
kubectl apply -f https://raw.githubusercontent.com/tyriis/i-see-dead-pods/main/manifests/service-account.yaml
kubectl apply -f https://raw.githubusercontent.com/tyriis/i-see-dead-pods/main/manifests/cluster-role.yaml
kubectl apply -f https://raw.githubusercontent.com/tyriis/i-see-dead-pods/main/manifests/cluster-role-binding.yaml
kubectl apply -f https://raw.githubusercontent.com/tyriis/i-see-dead-pods/main/manifests/cronjob.yaml
```

### kustomize

or with kustomize

### flux helmrelease

or with flux

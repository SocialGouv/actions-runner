# Runner container and infrastructure code for [Actions Runner Controller](https://github.com/actions-runner-controller/actions-runner-controller)

Run multiple self-hosted Github runners on a k8s cluster.

## Cluster configuration

### Ingress Controller

You need a k8s cluster with an **Ingress Controller** installed.

### `cert-manager`

Install `cert-manager` with the following command:

```bash
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.7.1/cert-manager.yaml
```

## Deployment with `helm` and `kubectl`

We'll deploy the controller with the following commands:

```bash
helm repo add actions-runner-controller https://actions-runner-controller.github.io/actions-runner-controller
helm upgrade --install --namespace actions-runner-system --create-namespace \
  --wait actions-runner-controller actions-runner-controller/actions-runner-controller \
  --version 0.17.0 \
  -f deployments/controller-values.yaml \
  --set "authSecret.github_token=<GITHUB_PAT>" \
  --set "githubWebhookServer.ingress.hosts[0].host=<CLUSTER_DOMAIN>" \
  --set "githubWebhookServer.secret.github_webhook_secret_token=<GITHUB_WEBHOOK_SECRET>"
```

Once both pods are running (one **controller** and one **Github webhook server**) we can deploy an **Horizontal Runner Autoscaler** and a **Runner Deployment**:

```bash
kubectl --context gh-runners apply -f deployments/runner-deployment.yaml
```

### The `dockerMTU` field

See [this blog article](https://mlohr.com/docker-mtu/) and [this issue](https://github.com/actions-runner-controller/actions-runner-controller/issues/651).

On a k8s cluster you don't necessarily get network interfaces with the **standard MTU of 1500**. Despite this, Docker always assumes that MTU is 1500 and you could get random **outgoing connections hanging indefinitely**. You can check this by connecting to a pod, running `ip link` and reading the outgoing interface's MTU value. If it is smaller than 1500, you need to copy this value and put it in the `dockerMTU` key in the RunnerDeployment.

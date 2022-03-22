# Runner container for [Actions Runner Controller](https://github.com/actions-runner-controller/actions-runner-controller)

Ephemeral Github runners on k8s

## Deployment with `helm` and `kubectl`

We'll deploy the controller with the following commands:

```bash
helm repo add actions-runner-controller https://actions-runner-controller.github.io/actions-runner-controller
helm upgrade --install --namespace actions-runner-system --create-namespace \
  --wait actions-runner-controller actions-runner-controller/actions-runner-controller \
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

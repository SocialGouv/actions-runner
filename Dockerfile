FROM summerwind/actions-runner-dind:v2.296.2-ubuntu-20.04

# INSTALL DEPENDENCIES

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
USER root

# Go
RUN curl -sL https://go.dev/dl/go1.17.linux-amd64.tar.gz | \
    tar -C /usr/local -xzf -
ENV PATH="${PATH}:/usr/local/go/bin"

# Kubectl
RUN curl -sL https://dl.k8s.io/release/v1.23.4/bin/linux/amd64/kubectl > /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl

# yq
RUN curl -sL https://github.com/mikefarah/yq/releases/download/v4.20.2/yq_linux_amd64.tar.gz | \
    tar -xzf - > /usr/local/bin/yq && \
    chmod +x /usr/local/bin/yq

# Helm
RUN curl -sL https://get.helm.sh/helm-v3.7.2-linux-amd64.tar.gz | \
    tar -xzf - --strip-components 1 -C /usr/local/bin linux-amd64/helm && \
    chmod +x /usr/local/bin/helm

# Kustomize
RUN curl -sL https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv4.5.2/kustomize_v4.5.2_linux_amd64.tar.gz | \
    tar -xzf - > /usr/local/bin/kustomize && \
    chmod +x /usr/local/bin/kustomize

# Chrome
RUN sh -c 'echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list' && \
    curl -sL https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    apt-get update && \
    apt-get install --no-install-recommends -y google-chrome-stable && \
    rm -rf /var/lib/apt/lists/*

# NodeJs
RUN curl -sL https://nodejs.org/dist/v16.15.0/node-v16.15.0-linux-x64.tar.xz | \
    tar -C /usr/local/lib -Jxf -
ENV PATH="${PATH}:/usr/local/lib/node-v16.15.0-linux-x64/bin"

# Yarn
RUN npm i -g yarn && \
    # Set env for all users
    sed -i 's@PATH=.*@PATH='"${PATH}"'@g' /etc/environment

USER runner

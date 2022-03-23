FROM summerwind/actions-runner-dind:latest

ARG NODE_VERSION=v16
ARG NVM_VERSION=v0.39.1

### INSTALL DEPENDENCIES ###

# Go
RUN curl -sL https://go.dev/dl/go1.17.linux-amd64.tar.gz > /tmp/go.tar.gz \
  && sudo tar -C /usr/local -xzf /tmp/go.tar.gz \
  && rm /tmp/go.tar.gz
ENV PATH="${PATH}:/usr/local/go/bin"

# Kubectl
RUN curl -sL https://dl.k8s.io/release/v1.23.4/bin/linux/amd64/kubectl > /tmp/kubectl \
  && sudo install -o root -g root -m 0755 /tmp/kubectl /usr/local/bin/kubectl \
  && rm /tmp/kubectl

# yq
RUN curl -sL https://github.com/mikefarah/yq/releases/download/v4.20.2/yq_linux_amd64.tar.gz | tar xz -C /tmp/ \
  && sudo install -o root -g root -m 0755 /tmp/yq_linux_amd64 /usr/local/bin/yq \
  && rm /tmp/yq_linux_amd64

# Helm
RUN curl -sL https://get.helm.sh/helm-v3.7.2-linux-amd64.tar.gz | tar xz -C /tmp/ \
  && sudo install -o root -g root -m 0755 /tmp/linux-amd64/helm /usr/local/bin/helm \
  && rm -r /tmp/linux-amd64

# Kustomize
RUN curl -sL https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv4.5.2/kustomize_v4.5.2_linux_amd64.tar.gz | tar xz -C /tmp/ \
  && sudo install -o root -g root -m 0755 /tmp/kustomize /usr/local/bin/kustomize \
  && rm /tmp/kustomize

# Chrome
RUN sudo sh -c 'echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list' \
  && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - \
  && sudo apt update \
  && sudo apt install -y google-chrome-stable

# Node.js v16
RUN wget -qO- https://deb.nodesource.com/setup_16.x | sudo -E bash - \
  && sudo apt install nodejs \
  && mkdir ~/.npm-global \
  && npm config set prefix '~/.npm-global'
ENV PATH="~/.npm-global/bin:${PATH}"

# Yarn
RUN npm install -g yarn

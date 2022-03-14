FROM summerwind/actions-runner:latest

### INSTALL DEPENDENCIES ###

# Node.js v16
RUN wget -qO- https://deb.nodesource.com/setup_16.x | sudo -E bash -
RUN sudo apt install nodejs

# Yarn
RUN sudo npm install -g yarn

# Kubectl
RUN wget -P /tmp/ "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
RUN sudo install -o root -g root -m 0755 /tmp/kubectl /usr/local/bin/kubectl

# yq
RUN wget -P /tmp/ https://github.com/mikefarah/yq/releases/download/v4.20.2/yq_linux_amd64.tar.gz
RUN tar xvzf /tmp/yq_linux_amd64.tar.gz -C /tmp/
RUN sudo mv /tmp/yq_linux_amd64 /usr/bin/yq

# Helm
RUN wget https://get.helm.sh/helm-v3.7.2-linux-amd64.tar.gz -P /tmp/
RUN tar xvzf /tmp/helm-v3.7.2-linux-amd64.tar.gz -C /tmp/
RUN sudo mv /tmp/linux-amd64/helm /usr/local/bin/helm

# Kustomize
RUN curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | sudo -E bash -

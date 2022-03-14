FROM summerwind/actions-runner-dind:latest

ARG NODE_VERSION=v16
ARG NVM_VERSION=v0.39.1

### INSTALL DEPENDENCIES ###
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
RUN curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | sudo bash

# NodeJs
ENV NVM_VERSION=$NVM_VERSION
ENV NVM_DIR=$HOME/.nvm
RUN mkdir -p $NVM_DIR
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh | bash
ENV NODE_VERSION=$NODE_VERSION
RUN chmod +x $NVM_DIR/nvm.sh && sudo ln -s $NVM_DIR/nvm.sh /usr/local/bin/nvm
RUN . $NVM_DIR/nvm.sh && \
    nvm install $NODE_VERSION && \
    nvm alias default $NODE_VERSION && \
    nvm use default && \
    npm i -g yarn
ENV NODE_PATH $NVM_DIR/$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/$NODE_VERSION/bin:$PATH

COPY nvm-entrypoint.sh /
RUN sudo chmod +x /nvm-entrypoint.sh
ENTRYPOINT ["/nvm-entrypoint.sh"]

CMD ["startup.sh"]

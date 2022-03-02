FROM myoung34/github-runner:latest

### INSTALL DEPENDENCIES ###

# Node.js v16
RUN wget -qO- https://deb.nodesource.com/setup_16.x | sudo -E bash -
RUN sudo apt install nodejs

# Yarn
RUN sudo npm install -g yarn

# Kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
RUN sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# yq
RUN wget https://github.com/mikefarah/yq/releases/download/v4.20.2/yq_linux_amd64.tar.gz -O - | tar xz && sudo mv yq_linux_amd64 /usr/bin/yq

# Helm
RUN wget https://get.helm.sh/helm-v3.7.2-linux-amd64.tar.gz
RUN tar xvzf helm-v3.7.2-linux-amd64.tar.gz
RUN mv linux-amd64/helm /usr/local/bin/helm

COPY entrypoint-decipher.sh /
RUN chmod +x /entrypoint-decipher.sh
ENTRYPOINT ["/entrypoint-decipher.sh"]

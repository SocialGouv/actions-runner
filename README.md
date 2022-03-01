# Actions Runner

ephemeral github runners in containers

## Concept

You'll have one or more runners on a host system. **Each runner** is in a **Docker container** thanks to [this project](https://github.com/myoung34/docker-github-actions-runner). We will use *ephemeral mode* : when a runner/container is started, it connects Github and waits for a job to run. When it receives and finishes its first job, it will **deregister from github** and the **container is removed**. Then, a **systemd service** runs a new container to **replace it**. This way the environment is clean for every job we run.

To register Github runners dynamically, we need to use a Github PAT (Personal Access Token). This token being **very sensitive**, we won't store it on the host's file system. Instead, we will store an encrypted version of it and use [SocialGouv/micro-cipher](https://github.com/SocialGouv/micro-cipher) to **decrypt it everytime** we need to start a new container.

## Installation

Pull the Docker image:

```bash
sudo docker pull ghcr.io/socialgouv/actions-runner:master
```

Clone this repository in the user's home:

```bash
cd $HOME && git clone https://github.com/SocialGouv/actions-runner.git
```

Copy the `runner.sh` script into `/usr/bin/`, preserving ownership:

```bash
sudo cp -p actions-runner/runner.sh /usr/bin/
```

Install `systemd` service:

```bash
sudo install -m 644 actions-runner/github-runner@.service /etc/systemd/system/
sudo systemctl daemon-reload
```

Create a **docker network** so that runners containers and the micro-cipher container can communicate:

```bash
docker network create cipher-net
```

Pull `micro-cipher`:

```bash
sudo docker pull ghcr.io/socialgouv/micro-cipher:main
```

Create the directory in which we'll store the encrypted Github token:

```bash
mkdir /tmp/github
```

## Startup

Run `micro-cipher`:

```bash
docker run -d --name micro-cipher --network cipher-net ghcr.io/socialgouv/micro-cipher:main
```

By running `docker logs micro-cipher` you should get the public key and a command hint to encrypt the token. Put the key in an `id_rsa.pem.pub` file and encrypt the key by running:

```bash
 echo "<token>" | openssl rsautl -encrypt -oaep -pubin -inkey id_rsa.pem.pub -out /tmp/github/github-token.enc
```
**Be careful to keep the whitespace at the beginning of the command to keep the token out of the bash history.**

Start some runner services:

```bash
sudo systemctl start github-runner@{1..4}
```

You may now see idle runner containers when running `docker ps`. You can get a runner's logs by running:

```bash
sudo journalctl -f -u github-runner@1.service --no-hostname --no-tail
```

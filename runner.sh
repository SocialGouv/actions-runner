#!/bin/bash

docker stop runner-$1
docker rm runner-$1

docker run \
	--rm \
	--name runner-$1 \
	-e RUNNER_WORKDIR=/tmp/runner-$1 \
	-e RUNNER_NAME=runner-$1 \
	-e RUNNER_SCOPE=org \
	-e ORG_NAME=SocialGouv \
	-e DISABLE_AUTO_UPDATE=true \
	-e EPHEMERAL=true \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v /tmp/runner-$1:/tmp/runner-$1 \
	-v /tmp/github:/tmp/github \
	--network cipher-net \
	# TODO reaal image name
	github-runner \
	/ephemeral-runner.sh


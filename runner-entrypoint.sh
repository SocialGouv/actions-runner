#!/bin/bash

export ACCESS_TOKEN=$(cat /tmp/github/github-token.enc | curl micro-cipher:3000 --data-binary @-)

. $NVM_DIR/nvm.sh

exec /entrypoint.sh $@


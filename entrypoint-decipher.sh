#!/bin/bash

export ACCESS_TOKEN=$(cat /github_token.enc | curl micro-cipher:3000 --data-binary @-)

exec /entrypoint.sh $@


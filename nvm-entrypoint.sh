#!/bin/bash

. $NVM_DIR/nvm.sh

exec /usr/local/bin/dumb-init -- $@

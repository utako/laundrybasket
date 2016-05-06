#!/usr/bin/env bash

go get github.com/pivotal-cf-experimental/bosh-bootloader/bbl

cd dirty-bosh-directors

tail -1 metadata > state.json

bbl destroy --no-confirm

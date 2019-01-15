#!/bin/bash

PWD="$( pwd )"
echo "${PWD}"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo "${DIR}"

docker volume create --driver local --opt type=none --opt device=/home/user/test --opt o=bind test_vol
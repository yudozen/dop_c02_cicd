#!/bin/sh
# entrypoint.sh

# terraform initを実行
terraform init

exec terraform "$@"
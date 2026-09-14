#!/bin/bash
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends git curl apt-transport-https ca-certificates gnupg lsb-release
sudo apt-get update -y || true

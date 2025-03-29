#!/bin/bash

sh "$(pwd)/src/scripts/pre-install.sh"

# Home directory customization
sh "$(pwd)/src/scripts/organizeHome.sh"

# CLI tools
sh "$(pwd)/src/scripts/cli.sh"

# Dev tools
sh "$(pwd)/src/scripts/dev.sh"

# Browsers, streaming, and video applications
sh "$(pwd)/src/scripts/media.sh"

# Productivity programs
sh "$(pwd)/src/scripts/productivity.sh"

# Security and penetration testing utilities
sh "$(pwd)/src/scripts/security.sh"

# Shell setup
zsh "$(pwd)/src/scripts/shell.sh"

sh "$(pwd)/src/scripts/post-install.sh"

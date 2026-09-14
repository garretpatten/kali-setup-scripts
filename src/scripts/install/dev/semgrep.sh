#!/bin/bash

if command -v semgrep >/dev/null 2>&1; then
    exit 0
fi

if command -v pipx >/dev/null 2>&1; then
    pipx install semgrep || pipx upgrade semgrep
else
    pip3 install --user --break-system-packages semgrep || true
fi

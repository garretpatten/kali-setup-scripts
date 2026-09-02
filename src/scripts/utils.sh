#!/bin/bash

is_installed() {
    local application="$1"
    command -v "$application" >/dev/null 2>&1
}

export ERROR_FILE="errors.log"

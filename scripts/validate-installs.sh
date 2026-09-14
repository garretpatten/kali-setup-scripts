#!/usr/bin/env bash
# Verify tools and apps installed by src/scripts/* after master.sh / run-install.sh all.
set -uo pipefail

cd "$(dirname "$0")/.." || exit 1

export PATH="${HOME}/.cargo/bin:${HOME}/.local/bin:/usr/local/bin:${PATH}"

# shellcheck source=scripts/lib/validate-common.sh
source scripts/lib/validate-common.sh
# shellcheck source=scripts/lib/validate-installs-sections.sh
source scripts/lib/validate-installs-sections.sh

validate_preflight
validate_cli_packages
validate_media
validate_security_cli
validate_security_desktop
validate_pass_cli
validate_nvm
validate_dev
validate_shell

finish_validation 'Install validation'

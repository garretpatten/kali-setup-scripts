#!/usr/bin/env bash
# Verify config outcomes after a standalone run-config.sh (no install).
set -uo pipefail

cd "$(dirname "$0")/.." || exit 1

# shellcheck source=scripts/lib/validate-common.sh
source scripts/lib/validate-common.sh
# shellcheck source=scripts/lib/validate-config-sections.sh
source scripts/lib/validate-config-sections.sh

validate_config_dotfiles
validate_config_home
validate_config_git

finish_validation 'Config-only validation'

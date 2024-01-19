#!/bin/sh

set -e

linter_latest_version() {
  curl -sL https://api.github.com/repos/golangci/golangci-lint/releases/latest | \
    grep '"tag_name":' | \
    awk '{gsub("\"",""); gsub(",",""); gsub("v",""); print $2}'
}

LINTER_DIR=${LINTER_DIR:-"./bin"}
LINTER_BIN="$LINTER_DIR/golangci-lint"
LINTER_VERSION=${LINTER_VERSION:-$(linter_latest_version)}

download_linter() {
  curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b "$LINTER_DIR" "v$LINTER_VERSION"
}

if [ ! -f "$LINTER_BIN" ]; then
  download_linter
fi

if ! "$LINTER_BIN" --version | grep -q "$LINTER_VERSION"; then
  download_linter
fi

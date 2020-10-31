#!/usr/bin/env bash

set -euxo pipefail

BASE_URL=https://raw.githubusercontent.com/brianloveswords/vscode-devcontainers/main/scala/.devcontainer

function main() {
    mkdir -p .devcontainer && cd "$_"
    curl -sSLO "${BASE_URL}"/Dockerfile
    curl -sSLO "${BASE_URL}"/devcontainer.json
}

main

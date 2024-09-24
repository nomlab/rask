#!/bin/bash

cd "$(dirname "$0")" || exit 1

REPO_NAME="nomlab/rask"

# Get current tag of this repository
current_tag=$(git describe --tags --abbrev=0)

# Get latest tag from GitHub
latest_tag=$(curl  "https://api.github.com/repos/$REPO_NAME/releases/latest" | jq -r '.tag_name')

# If the latest tag is newer than the current tag, update the Rask
if [[ "$latest_tag" > "$current_tag" ]]; then
    # Pull latest tag
    git pull origin "$latest_tag"

    # Update Rask image
    ./script/setup-docker.sh "$USER"

    # Stop Rask container and then Rask is restarted by systemd
    ./rask-docker.sh stop
fi


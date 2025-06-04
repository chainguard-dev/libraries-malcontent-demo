#!/usr/bin/env bash

set -euo pipefail

REPO_URL="https://github.com/chainguard-dev/malcontent-samples.git"
LOCAL_REPO_DIR="malcontent-samples"
ULTRALYTICS_SUBDIR="python/2024.ultralytics"
IMAGE="cgr.dev/chainguard/malcontent@sha256:fdfca44c401a5ca98af51292a821278644895bc1963f7a76a733d76647ff0ede"

echo ""
if [[ -d "./$LOCAL_REPO_DIR" ]]; then
  echo "[*] Using existing local repo at $LOCAL_REPO_DIR"
else
  echo "[*] Cloning repository into (shallow)..."
  git clone --depth=1 --branch main --single-branch "$REPO_URL" "."
fi

FULLBASEPATH="$PWD/$LOCAL_REPO_DIR/$ULTRALYTICS_SUBDIR"
echo "FULLBASEPATH=$FULLBASEPATH"

echo "[*] Analyze Ultralytics v8.3.40"
docker run --rm -v "$FULLBASEPATH:/home/nonroot/malcontent/" "$IMAGE" \
  --min-risk=medium \
  --stats \
  analyze /home/nonroot/malcontent/v8.3.40
echo ""

echo "[*] Analyze Ultralytics v8.3.41"
docker run --rm -v "$FULLBASEPATH:/home/nonroot/malcontent/" "$IMAGE" \
  --include-data-files=true \
  --min-risk=medium \
  --quantity-increases-risk=true \
  --stats \
  analyze /home/nonroot/malcontent/v8.3.41
echo ""

echo "[*] Diffing Ultralytics v8.3.40  ↔ v8.3.41"
CONTAINER_NAME="malcontent-diff-temp"
docker run --name "$CONTAINER_NAME" -v "$FULLBASEPATH:/home/nonroot/malcontent/" "$IMAGE" \
  --min-risk=high \
  --format=json \
  --output=/home/nonroot/ultralytics-malcontent-diff-v8.3.40-v8.3.41.json \
  diff \
  --file-risk-increase=true \
  /home/nonroot/malcontent/v8.3.40 /home/nonroot/malcontent/v8.3.41

echo "[*] Extracting JSON"
mkdir scans
docker cp "$CONTAINER_NAME:/home/nonroot/ultralytics-malcontent-diff-v8.3.40-v8.3.41.json" scans/
docker rm "$CONTAINER_NAME" > /dev/null
echo "[*] Output saved to scans/ultralytics-malcontent-diff-v8.3.40-v8.3.41.json"
echo ""
echo "[✔] Done"

#!/bin/bash
set -e

chown -R openclaw:openclaw /data
chmod 700 /data

if [ ! -d /data/.linuxbrew ]; then
  cp -a /home/linuxbrew/.linuxbrew /data/.linuxbrew
fi

rm -rf /home/linuxbrew/.linuxbrew
ln -sfn /data/.linuxbrew /home/linuxbrew/.linuxbrew

# Install/update the CurryChat plugin on every boot.
# This ensures node_modules are always present (they don't survive container restarts).
echo "[entrypoint] Installing @lambdacurry/openclaw-currychat-plugin..."
gosu openclaw env \
  OPENCLAW_STATE_DIR="${OPENCLAW_STATE_DIR:-/data/.openclaw}" \
  openclaw plugins install @lambdacurry/openclaw-currychat-plugin 2>&1 || \
  echo "[entrypoint] Warning: CurryChat plugin install failed (non-fatal)"

exec gosu openclaw node src/server.js

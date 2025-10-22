#!/usr/bin/env bash
set -euo pipefail

echo "🚀 Netlify build started"
echo "📁 Working dir: $(pwd)"

# Configure versions
FLUTTER_VERSION_ENV="${FLUTTER_VERSION:-3.27.0}"
NODE_VERSION_ENV="${NODE_VERSION:-18}"

echo "🔧 Using Flutter ${FLUTTER_VERSION_ENV} and Node ${NODE_VERSION_ENV}"

echo "🔧 Ensuring Node ${NODE_VERSION_ENV} is active (Netlify)"
if command -v nvm >/dev/null 2>&1; then
  # shellcheck disable=SC1090
  source "$NVM_DIR/nvm.sh" || true
  nvm install "${NODE_VERSION_ENV}" || true
  nvm use "${NODE_VERSION_ENV}" || true
fi
node -v || true
npm -v || true

echo "📦 Installing Flutter ${FLUTTER_VERSION_ENV}"
FLUTTER_TAR="flutter_linux_${FLUTTER_VERSION_ENV}-stable.tar.xz"
FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/${FLUTTER_TAR}"

curl -fsSL -o "${FLUTTER_TAR}" "${FLUTTER_URL}"
tar -xf "${FLUTTER_TAR}"
export PATH="$(pwd)/flutter/bin:${PATH}"

echo "🧪 Flutter version"
flutter --version

echo "🛠 Enabling web support"
flutter config --enable-web

echo "📚 Pub get"
flutter pub get

echo "🏗 Building web"
flutter build web --release

echo "📁 Post-build steps"
if [ -f "web_config/_redirects" ]; then
  cp web_config/_redirects build/web/
fi

echo "📦 Build output: build/web"
ls -la build/web || true

echo "✅ Netlify build finished"



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

echo "🌐 Ensuring production environment"
# Force production environment in environment.dart
sed -i 's/static const Environment _currentEnvironment = Environment\.[^;]*;/static const Environment _currentEnvironment = Environment.production;/' lib/core/constants/environment.dart
echo "✅ Environment set to production"

echo "📚 Pub get"
flutter pub get

echo "🏗 Building web (HTML renderer)"
flutter build web --release --web-renderer html

echo "📁 Post-build steps"
# Генерируем уникальную версию для cache busting
BUILD_VERSION=$(date +%Y%m%d-%H%M%S 2>/dev/null || echo "$(date +%s)")
echo "📝 Setting build version to: $BUILD_VERSION"
if [ -f "build/web/index.html" ]; then
  sed -i.bak "s/<meta name=\"app-version\" content=\"[^\"]*\">/<meta name=\"app-version\" content=\"$BUILD_VERSION\">/" build/web/index.html || true
  rm -f build/web/index.html.bak
fi

echo "📁 Post-build file operations"
if [ -f "web_config/_redirects" ]; then
  cp web_config/_redirects build/web/
fi

echo "📦 Build output: build/web"
ls -la build/web || true

echo "✅ Netlify build finished"



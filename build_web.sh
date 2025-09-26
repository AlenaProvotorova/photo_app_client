#!/bin/bash

echo "🛠 Сборка Flutter Web..."
flutter build web

echo "📁 Копирование _redirects в build/web..."
cp web_config/_redirects build/web/

echo "✅ Готово! Теперь можно загружать build/web на Netlify"

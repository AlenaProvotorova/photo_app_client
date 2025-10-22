#!/bin/bash

echo "🚀 Начинаем сборку Flutter Web..."
echo "📁 Текущая директория: $(pwd)"
echo "📋 Содержимое директории:"
ls -la

echo "🔍 Проверяем Flutter..."
flutter --version

echo "🛠 Сборка Flutter Web..."
flutter build web --verbose

echo "📁 Проверяем результат сборки..."
if [ -d "build/web" ]; then
    echo "✅ Папка build/web создана успешно"
    echo "📋 Содержимое build/web:"
    ls -la build/web/
else
    echo "❌ Папка build/web не найдена!"
    echo "📋 Содержимое build/:"
    ls -la build/ || echo "Папка build не существует"
    exit 1
fi

echo "📁 Копирование _redirects в build/web..."
if [ -f "web_config/_redirects" ]; then
    cp web_config/_redirects build/web/
    echo "✅ _redirects скопирован"
else
    echo "⚠️ Файл web_config/_redirects не найден"
fi

echo "✅ Готово! Теперь можно загружать build/web на Netlify"
echo "📋 Финальное содержимое build/web:"
ls -la build/web/

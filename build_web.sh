#!/bin/bash

echo "🚀 Начинаем сборку Flutter Web..."
echo "📁 Текущая директория: $(pwd)"
echo "📋 Содержимое директории:"
ls -la

echo "🔍 Проверяем Flutter..."
flutter --version

echo "🛠 Сборка Flutter Web (HTML renderer для максимальной совместимости)..."
flutter build web --release --web-renderer html

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

echo "📁 Копирование конфигурационных файлов в build/web..."

# Копируем _redirects для Netlify
if [ -f "web_config/_redirects" ]; then
    cp web_config/_redirects build/web/
    echo "✅ _redirects скопирован"
else
    echo "⚠️ Файл web_config/_redirects не найден"
fi

# Копируем .htaccess для Reg.ru и других Apache хостингов
if [ -f "web_config/.htaccess" ]; then
    cp web_config/.htaccess build/web/
    echo "✅ .htaccess скопирован"
else
    echo "⚠️ Файл web_config/.htaccess не найден"
fi

echo "✅ Готово! Теперь можно загружать build/web на хостинг"
echo "📋 Финальное содержимое build/web:"
ls -la build/web/

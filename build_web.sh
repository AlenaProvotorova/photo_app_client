#!/bin/bash

echo "🛠 Сборка Flutter Web..."
flutter build web --release

echo "📁 Копирование конфигурационных файлов в build/web..."

# Копирование _redirects для Netlify
if [ -f web_config/_redirects ]; then
    cp web_config/_redirects build/web/
    echo "   ✅ _redirects скопирован"
fi

# Копирование robots.txt
if [ -f web_config/robots.txt ]; then
    cp web_config/robots.txt build/web/
    echo "   ✅ robots.txt скопирован"
fi

echo "🔧 Настройка прав доступа..."
chmod 644 build/web/robots.txt 2>/dev/null || true

echo "📊 Информация о сборке:"
echo "   Размер папки build/web: $(du -sh build/web | cut -f1)"
echo "   Количество файлов: $(find build/web -type f | wc -l)"

echo ""
echo "✅ Готово! Приложение готово для деплоя на Netlify"
echo "🚀 Для деплоя:"
echo "   1. Закоммитьте изменения: git add . && git commit -m 'Update build'"
echo "   2. Запушьте в GitHub: git push origin main"
echo "   3. Netlify автоматически задеплоит приложение"
echo ""
echo "🌐 Для настройки кастомного домена:"
echo "   1. В панели Netlify: Site settings → Domain management"
echo "   2. Добавьте ваш домен"
echo "   3. Настройте DNS записи"
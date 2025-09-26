#!/bin/bash

# Скрипт для развертывания на Reg.ru
# Использование: ./scripts/deploy_regru.sh [domain]

DOMAIN=${1:-"yourdomain.ru"}
BUILD_DIR="build/web"
TEMP_DIR="temp_deploy"

echo "🚀 Развертывание Photo App на Reg.ru"
echo "🌐 Домен: $DOMAIN"

# Проверка наличия сборки
if [ ! -d "$BUILD_DIR" ]; then
    echo "❌ Папка $BUILD_DIR не найдена. Сначала выполните сборку:"
    echo "   ./build_web.sh"
    exit 1
fi

# Создание временной папки
echo "📁 Создание временной папки для развертывания..."
rm -rf $TEMP_DIR
mkdir -p $TEMP_DIR

# Копирование файлов
echo "📋 Копирование файлов..."
cp -r $BUILD_DIR/* $TEMP_DIR/

# Создание архива для загрузки
echo "📦 Создание архива для загрузки..."
cd $TEMP_DIR
zip -r "../photo_app_deploy.zip" . -x "*.DS_Store" "*.git*"
cd ..

echo "✅ Архив создан: photo_app_deploy.zip"
echo ""
echo "📋 Инструкции для загрузки на Reg.ru:"
echo "1. Войти в панель управления Reg.ru"
echo "2. Перейти в раздел 'Хостинг' → 'Файловый менеджер'"
echo "3. Открыть папку public_html"
echo "4. Удалить все файлы из public_html (если есть)"
echo "5. Загрузить и распаковать photo_app_deploy.zip"
echo "6. Или загрузить файлы через FTP:"
echo "   - Хост: ftp.$DOMAIN"
echo "   - Папка: public_html"
echo ""
echo "🔧 После загрузки:"
echo "1. Настроить SSL-сертификат (Let's Encrypt)"
echo "2. Включить принудительное перенаправление на HTTPS в .htaccess"
echo "3. Проверить работу сайта: https://$DOMAIN"
echo ""
echo "📊 Статистика развертывания:"
echo "   Размер архива: $(du -sh photo_app_deploy.zip | cut -f1)"
echo "   Количество файлов: $(find $TEMP_DIR -type f | wc -l)"

# Очистка временной папки
rm -rf $TEMP_DIR

echo ""
echo "🎉 Готово! Приложение подготовлено для развертывания на Reg.ru"


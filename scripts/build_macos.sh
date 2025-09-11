#!/bin/bash

# Скрипт для сборки macOS приложения
echo "🚀 Начинаем сборку macOS приложения..."

# Проверяем, что мы в правильной директории
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Ошибка: Запустите скрипт из корневой директории проекта"
    exit 1
fi

# Получаем версию из pubspec.yaml
VERSION=$(grep "version:" pubspec.yaml | sed 's/version: //')
echo "📦 Версия приложения: $VERSION"

# Обновляем зависимости
echo "📥 Обновляем зависимости..."
flutter pub get

# Очищаем предыдущие сборки
echo "🧹 Очищаем предыдущие сборки..."
flutter clean
flutter pub get

# Собираем релизную версию
echo "🔨 Собираем релизную версию для macOS..."
flutter build macos --release

# Проверяем успешность сборки
if [ $? -eq 0 ]; then
    echo "✅ Сборка macOS успешно завершена!"
    
    # Создаем DMG
    echo "📦 Создаем DMG дистрибутив..."
    create-dmg \
        --volname "Photo App $VERSION" \
        --window-pos 200 120 \
        --window-size 600 300 \
        --icon-size 100 \
        --icon "photo_app.app" 175 120 \
        --hide-extension "photo_app.app" \
        --app-drop-link 425 120 \
        "PhotoApp-$VERSION.dmg" \
        "build/macos/Build/Products/Release/"
    
    if [ $? -eq 0 ]; then
        echo "✅ DMG дистрибутив создан: PhotoApp-$VERSION.dmg"
        echo "📁 Размер файла: $(du -h PhotoApp-$VERSION.dmg | cut -f1)"
    else
        echo "❌ Ошибка при создании DMG"
        exit 1
    fi
else
    echo "❌ Ошибка при сборке macOS приложения"
    exit 1
fi

echo "🎉 Готово! macOS приложение готово к распространению"

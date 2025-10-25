#!/bin/bash

# 🚀 Скрипт автоматической сборки релиза Photo App для macOS
# Автор: AI Assistant
# Дата: 23.10.2024

set -e  # Остановить выполнение при ошибке

echo "🚀 Начинаем сборку релиза Photo App для macOS..."

# Получить текущую дату для версионирования
VERSION=$(date +%Y%m%d_%H%M)
ARCHIVE_NAME="photo_app_macos_release_v${VERSION}.zip"

echo "📅 Версия: $VERSION"
echo "📦 Архив: $ARCHIVE_NAME"

# Шаг 1: Остановить процессы
echo "⏹️ Останавливаем все процессы приложения..."
pkill -f photo_app || true  # Игнорировать ошибку если процессов нет

# Шаг 2: Очистить файлы блокировки
echo "🧹 Очищаем файлы блокировки Hive..."
rm -f ~/Library/Containers/com.example.photoApp/Data/Documents/*.lock || true

# Шаг 3: Очистить кэш Flutter (опционально)
echo "🔄 Очищаем кэш Flutter..."
flutter clean

# Шаг 4: Получить зависимости
echo "📥 Получаем зависимости..."
flutter pub get

# Шаг 5: Создать релизную сборку
echo "🔨 Создаем релизную сборку для macOS..."
flutter build macos --release

# Проверить успешность сборки
if [ ! -d "build/macos/Build/Products/Release/photo_app.app" ]; then
    echo "❌ Ошибка: Сборка не удалась!"
    exit 1
fi

echo "✅ Сборка успешно создана!"

# Шаг 6: Создать архив
echo "📦 Создаем архив для распространения..."
cd build/macos/Build/Products/Release

# Удалить старые архивы если есть
rm -f photo_app_macos_release_v*.zip

# Создать новый архив
zip -r "$ARCHIVE_NAME" photo_app.app

# Переместить архив в корень проекта
mv "$ARCHIVE_NAME" ../../../../../

# Вернуться в корень проекта
cd ../../../../../

# Шаг 7: Проверить размер архива
ARCHIVE_SIZE=$(ls -lh "$ARCHIVE_NAME" | awk '{print $5}')
echo "📊 Размер архива: $ARCHIVE_SIZE"

# Шаг 8: Запустить приложение для тестирования
echo "🚀 Запускаем приложение для тестирования..."
open build/macos/Build/Products/Release/photo_app.app

echo ""
echo "🎉 Релиз успешно создан!"
echo "📁 Приложение: build/macos/Build/Products/Release/photo_app.app"
echo "📦 Архив: $ARCHIVE_NAME ($ARCHIVE_SIZE)"
echo ""
echo "✅ Готово к распространению!"
echo ""
echo "📋 Следующие шаги:"
echo "   1. Протестируйте приложение"
echo "   2. Проверьте функциональность"
echo "   3. Распространите архив $ARCHIVE_NAME"

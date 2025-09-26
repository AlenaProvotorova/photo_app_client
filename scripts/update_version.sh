#!/bin/bash

# Скрипт для обновления версии приложения
echo "🔄 Обновление версии приложения..."

# Проверяем аргументы
if [ $# -eq 0 ]; then
    echo "Использование: $0 <новая_версия>"
    echo "Пример: $0 1.0.1"
    exit 1
fi

NEW_VERSION=$1
CURRENT_VERSION=$(grep "version:" pubspec.yaml | sed 's/version: //')
CURRENT_BUILD=$(echo $CURRENT_VERSION | cut -d'+' -f2)
NEW_BUILD=$((CURRENT_BUILD + 1))
FULL_VERSION="$NEW_VERSION+$NEW_BUILD"

echo "📦 Текущая версия: $CURRENT_VERSION"
echo "📦 Новая версия: $FULL_VERSION"

# Обновляем pubspec.yaml
sed -i.bak "s/version: .*/version: $FULL_VERSION/" pubspec.yaml

# Обновляем версию в Windows ресурсах
if [ -f "windows/runner/Runner.rc" ]; then
    sed -i.bak "s/#define VERSION_AS_STRING .*/#define VERSION_AS_STRING \"$NEW_VERSION\"/" windows/runner/Runner.rc
    sed -i.bak "s/#define VERSION_AS_NUMBER .*/#define VERSION_AS_NUMBER $NEW_VERSION,0,0,0/" windows/runner/Runner.rc
fi

# Обновляем версию в macOS Info.plist
if [ -f "macos/Runner/Info.plist" ]; then
    # Версия уже берется из Flutter, но можно добавить дополнительные настройки
    echo "✅ Версия обновлена в macOS конфигурации"
fi

echo "✅ Версия успешно обновлена до $FULL_VERSION"
echo "📝 Не забудьте закоммитить изменения:"
echo "   git add ."
echo "   git commit -m \"Bump version to $FULL_VERSION\""
echo "   git tag v$NEW_VERSION"

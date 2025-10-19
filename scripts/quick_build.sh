#!/bin/bash

# Быстрый скрипт для сборки Windows приложения
echo "⚡ Быстрая сборка Windows приложения..."

# Цвета
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Проверяем аргументы
if [ "$1" = "--release" ]; then
    echo -e "${BLUE}🎉 Создаем релиз...${NC}"
    ./scripts/create_release.sh
else
    echo -e "${BLUE}🔨 Запускаем сборку...${NC}"
    ./scripts/build_windows_github.sh "$@"
fi

echo -e "${GREEN}✅ Готово!${NC}"

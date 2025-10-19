#!/bin/bash

# Скрипт для создания релиза с Windows приложением
echo "🎉 Создаем релиз с Windows приложением..."

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Функция для вывода сообщений
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Проверяем, что мы в правильной директории
if [ ! -f "pubspec.yaml" ]; then
    print_error "Запустите скрипт из корневой директории проекта"
    exit 1
fi

# Получаем версию из pubspec.yaml
VERSION=$(grep "version:" pubspec.yaml | sed 's/version: //')
print_status "Версия приложения: $VERSION"

# Проверяем, что версия не содержит dev, beta, alpha
if [[ $VERSION == *"dev"* ]] || [[ $VERSION == *"beta"* ]] || [[ $VERSION == *"alpha"* ]]; then
    print_warning "Версия содержит пре-релизные метки: $VERSION"
    read -p "Продолжить создание пре-релиза? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_status "Отменено пользователем"
        exit 0
    fi
fi

# Создаем тег
TAG_NAME="v$VERSION"
print_status "Создаем тег: $TAG_NAME"

# Проверяем, что тег не существует
if git tag -l | grep -q "^$TAG_NAME$"; then
    print_error "Тег $TAG_NAME уже существует"
    print_status "Существующие теги:"
    git tag -l | tail -5
    exit 1
fi

# Создаем тег
if git tag -a "$TAG_NAME" -m "Release $TAG_NAME"; then
    print_success "Тег $TAG_NAME создан"
else
    print_error "Ошибка при создании тега"
    exit 1
fi

# Отправляем тег в GitHub
print_status "Отправляем тег в GitHub..."
if git push origin "$TAG_NAME"; then
    print_success "Тег отправлен в GitHub"
else
    print_error "Ошибка при отправке тега"
    exit 1
fi

# Получаем информацию о репозитории
REPO_URL=$(git remote get-url origin)
REPO_NAME=$(echo $REPO_URL | sed 's/.*github.com[:/]\([^/]*\/[^/]*\)\.git.*/\1/')

print_success "Релиз $TAG_NAME создан!"
echo ""
print_status "Ссылки:"
echo -e "${BLUE}🔗 Actions:${NC} https://github.com/$REPO_NAME/actions"
echo -e "${BLUE}📦 Releases:${NC} https://github.com/$REPO_NAME/releases"
echo -e "${BLUE}🏷️  Tag:${NC} https://github.com/$REPO_NAME/releases/tag/$TAG_NAME"
echo ""

# Проверяем, есть ли GitHub CLI
if command -v gh &> /dev/null; then
    print_status "GitHub CLI найден. Открываем релиз..."
    gh release view "$TAG_NAME" || print_warning "Релиз еще создается, подождите несколько минут"
else
    print_warning "GitHub CLI не установлен. Установите для удобного управления релизами:"
    echo "brew install gh"
fi

print_success "Готово! Релиз $TAG_NAME будет создан автоматически после завершения сборки"

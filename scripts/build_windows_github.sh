#!/bin/bash

# Скрипт для запуска сборки Windows приложения через GitHub Actions
echo "🚀 Запускаем сборку Windows приложения через GitHub Actions..."

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

# Проверяем, что git настроен
if [ ! -d ".git" ]; then
    print_error "Это не git репозиторий"
    exit 1
fi

# Проверяем, что есть remote origin
if ! git remote get-url origin > /dev/null 2>&1; then
    print_error "Не настроен remote origin"
    print_status "Настройте remote origin: git remote add origin <your-repo-url>"
    exit 1
fi

# Получаем информацию о репозитории
REPO_URL=$(git remote get-url origin)
REPO_NAME=$(echo $REPO_URL | sed 's/.*github.com[:/]\([^/]*\/[^/]*\)\.git.*/\1/')

print_status "Репозиторий: $REPO_NAME"
print_status "URL: $REPO_URL"

# Получаем текущую ветку
CURRENT_BRANCH=$(git branch --show-current)
print_status "Текущая ветка: $CURRENT_BRANCH"

# Получаем версию из pubspec.yaml
VERSION=$(grep "version:" pubspec.yaml | sed 's/version: //')
print_status "Версия приложения: $VERSION"

# Проверяем статус git
if [ -n "$(git status --porcelain)" ]; then
    print_warning "Есть несохраненные изменения"
    print_status "Добавляем все изменения в коммит..."
    git add .
    
    # Спрашиваем сообщение коммита
    if [ -z "$1" ]; then
        COMMIT_MSG="Trigger Windows build - $(date '+%Y-%m-%d %H:%M:%S')"
    else
        COMMIT_MSG="$1"
    fi
    
    git commit -m "$COMMIT_MSG"
    print_success "Изменения закоммичены: $COMMIT_MSG"
else
    print_status "Нет изменений для коммита"
fi

# Отправляем в GitHub
print_status "Отправляем изменения в GitHub..."
if git push origin $CURRENT_BRANCH; then
    print_success "Изменения отправлены в GitHub"
else
    print_error "Ошибка при отправке в GitHub"
    exit 1
fi

# Выводим ссылки
echo ""
print_success "Сборка запущена! Проверьте статус:"
echo -e "${BLUE}🔗 Actions:${NC} https://github.com/$REPO_NAME/actions"
echo -e "${BLUE}📦 Releases:${NC} https://github.com/$REPO_NAME/releases"
echo ""

# Проверяем, есть ли GitHub CLI
if command -v gh &> /dev/null; then
    print_status "GitHub CLI найден. Открываем Actions..."
    gh run list --limit 1
    echo ""
    print_status "Для просмотра логов выполните:"
    echo "gh run watch"
else
    print_warning "GitHub CLI не установлен. Установите для удобного просмотра логов:"
    echo "brew install gh"
fi

echo ""
print_success "Готово! Следите за прогрессом сборки в GitHub Actions"
print_status "После завершения сборки скачайте артефакт из раздела Actions"

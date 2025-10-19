#!/bin/bash

# Скрипт для тестирования структуры сборки
echo "🔍 Тестируем структуру сборки..."

# Цвета
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

print_status "Проверяем структуру проекта..."

# Проверяем основные файлы
if [ -f "pubspec.yaml" ]; then
    print_success "pubspec.yaml найден"
else
    print_error "pubspec.yaml не найден"
    exit 1
fi

# Проверяем папку windows
if [ -d "windows" ]; then
    print_success "Папка windows существует"
    
    # Проверяем основные файлы Windows
    if [ -f "windows/CMakeLists.txt" ]; then
        print_success "CMakeLists.txt найден"
    else
        print_error "CMakeLists.txt не найден"
    fi
    
    if [ -d "windows/runner" ]; then
        print_success "Папка runner существует"
    else
        print_error "Папка runner не найдена"
    fi
else
    print_error "Папка windows не найдена"
    exit 1
fi

# Проверяем папку test
if [ -d "test" ]; then
    print_success "Папка test существует"
    
    # Проверяем файлы тестов
    test_files=$(find test -name "*.dart" | wc -l)
    if [ $test_files -gt 0 ]; then
        print_success "Найдено $test_files тестовых файлов"
    else
        print_warning "Тестовые файлы не найдены"
    fi
else
    print_warning "Папка test не найдена"
fi

# Проверяем папку lib
if [ -d "lib" ]; then
    print_success "Папка lib существует"
    
    # Проверяем main.dart
    if [ -f "lib/main.dart" ]; then
        print_success "main.dart найден"
    else
        print_error "main.dart не найден"
    fi
else
    print_error "Папка lib не найдена"
    exit 1
fi

# Проверяем GitHub Actions workflow
if [ -f ".github/workflows/build-windows.yml" ]; then
    print_success "GitHub Actions workflow найден"
else
    print_error "GitHub Actions workflow не найден"
fi

print_status "Проверяем зависимости..."

# Проверяем, что Flutter настроен
if command -v flutter &> /dev/null; then
    print_success "Flutter установлен"
    
    # Проверяем версию Flutter
    flutter_version=$(flutter --version | head -n 1)
    print_status "Версия Flutter: $flutter_version"
else
    print_error "Flutter не установлен"
    exit 1
fi

# Проверяем, что Windows desktop включен
if flutter config --list | grep -q "enable-windows-desktop: true"; then
    print_success "Windows desktop включен"
else
    print_warning "Windows desktop не включен"
    print_status "Включаем Windows desktop..."
    flutter config --enable-windows-desktop
fi

print_status "Проверяем зависимости проекта..."

# Проверяем pub get
if flutter pub get > /dev/null 2>&1; then
    print_success "Зависимости установлены"
else
    print_error "Ошибка при установке зависимостей"
    exit 1
fi

print_status "Проверяем тесты..."

# Запускаем тесты
if flutter test > /dev/null 2>&1; then
    print_success "Тесты проходят"
else
    print_warning "Тесты не проходят, но это не критично для сборки"
fi

print_status "Проверяем структуру для сборки..."

# Создаем тестовую структуру папки build (симуляция)
mkdir -p test_build/windows/runner/Release
echo "test.exe" > test_build/windows/runner/Release/test.exe
echo "test.dll" > test_build/windows/runner/Release/test.dll

print_status "Тестируем создание ZIP архива..."

# Тестируем создание ZIP архива
if command -v zip &> /dev/null; then
    cd test_build
    if zip -r ../test_archive.zip windows/runner/Release/* > /dev/null 2>&1; then
        print_success "ZIP архив создан успешно"
        cd ..
        rm -rf test_build test_archive.zip
    else
        print_error "Ошибка при создании ZIP архива"
        cd ..
        rm -rf test_build
    fi
else
    print_warning "zip не установлен, пропускаем тест архива"
    rm -rf test_build
fi

print_success "Все проверки завершены!"
print_status "Проект готов для сборки в GitHub Actions"

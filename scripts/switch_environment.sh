#!/bin/bash

# Скрипт для переключения окружений
echo "🔄 Переключение окружения..."

if [ $# -eq 0 ]; then
    echo "Использование: $0 <environment>"
    echo "Доступные окружения:"
    echo "  development - локальная разработка (http://127.0.0.1:3000/api/)"
    echo "  staging     - тестовый сервер (http://127.0.0.1:3000/api/)"
    echo "  production  - продакшн сервер (https://api.fastselect.ru/api/)"
    exit 1
fi

ENVIRONMENT=$1

case $ENVIRONMENT in
    "development"|"dev")
        echo "🔧 Переключаемся на development окружение..."
        sed -i.bak 's/static const Environment _currentEnvironment = Environment\.[^;]*;/static const Environment _currentEnvironment = Environment.development;/' lib/core/constants/environment.dart
        echo "✅ Переключено на development"
        echo "📡 API URL: http://127.0.0.1:3000/api/"
        echo "⚠️  Убедитесь, что локальный сервер запущен!"
        ;;
    "staging"|"stage")
        echo "🔧 Переключаемся на staging окружение..."
        sed -i.bak 's/static const Environment _currentEnvironment = Environment\.[^;]*;/static const Environment _currentEnvironment = Environment.staging;/' lib/core/constants/environment.dart
        echo "✅ Переключено на staging"
        echo "📡 API URL: http://127.0.0.1:3000/api/"
        ;;
    "production"|"prod")
        echo "🔧 Переключаемся на production окружение..."
        sed -i.bak 's/static const Environment _currentEnvironment = Environment\.[^;]*;/static const Environment _currentEnvironment = Environment.production;/' lib/core/constants/environment.dart
        echo "✅ Переключено на production"
        echo "📡 API URL: https://api.fastselect.ru/api/"
        ;;
    *)
        echo "❌ Неизвестное окружение: $ENVIRONMENT"
        echo "Доступные окружения: development, staging, production"
        exit 1
        ;;
esac

echo ""
echo "🧪 Тестируем подключение к API..."
dart scripts/test_api.dart

# 🔧 Настройка API и решение проблем CORS

## 📋 Текущий статус

- ✅ **CORS настройки исправлены** - добавлены правильные заголовки
- ✅ **URL настроен на продакшн** - `https://photoappserver-production.up.railway.app/api/`
- ❌ **Продакшн сервер недоступен** - возвращает 502 ошибку
- ❌ **Локальный сервер не запущен** - Connection refused

## 🚨 Проблемы и решения

### 1. CORS ошибки
**Проблема:** Браузер блокирует запросы из-за CORS политики

**Решение:** ✅ Исправлено
- Добавлены CORS заголовки в `DioClient`
- Создан `CorsInterceptor` для обработки preflight запросов
- Добавлен `ErrorHandlingInterceptor` для лучшей обработки ошибок

### 2. Продакшн сервер недоступен (502 ошибка)
**Проблема:** `https://photoappserver-production.up.railway.app/api/` возвращает 502

**Возможные причины:**
- Сервер не запущен на Railway
- Проблемы с конфигурацией сервера
- Превышен лимит ресурсов

**Решения:**
1. **Проверить статус сервера на Railway**
2. **Перезапустить сервер**
3. **Проверить логи сервера**
4. **Использовать staging окружение**

### 3. Локальный сервер не запущен
**Проблема:** `http://127.0.0.1:3000/api/` недоступен

**Решение:**
```bash
# Запустить локальный сервер
cd /path/to/your/backend
npm start
# или
yarn start
# или
python app.py
```

## 🔄 Переключение окружений

### Автоматическое переключение
```bash
# Development (локальный сервер)
./scripts/switch_environment.sh development

# Staging (тестовый сервер)
./scripts/switch_environment.sh staging

# Production (продакшн сервер)
./scripts/switch_environment.sh production
```

### Ручное переключение
В файле `lib/core/constants/environment.dart`:
```dart
static const Environment _currentEnvironment = Environment.development; // или staging, production
```

## 🧪 Тестирование API

### Автоматическое тестирование
```bash
dart scripts/test_api.dart
```

### Ручное тестирование
```bash
# Тест продакшн сервера
curl -I https://photoappserver-production.up.railway.app/api/

# Тест локального сервера
curl -I http://127.0.0.1:3000/api/
```

## 📝 Настройка для разработки

### 1. Локальная разработка
```bash
# 1. Переключиться на development
./scripts/switch_environment.sh development

# 2. Запустить локальный сервер
cd /path/to/backend
npm start

# 3. Запустить Flutter приложение
flutter run -d macos
```

### 2. Тестирование на staging
```bash
# 1. Переключиться на staging
./scripts/switch_environment.sh staging

# 2. Запустить Flutter приложение
flutter run -d macos
```

### 3. Продакшн деплой
```bash
# 1. Убедиться, что продакшн сервер работает
curl -I https://photoappserver-production.up.railway.app/api/

# 2. Переключиться на production
./scripts/switch_environment.sh production

# 3. Собрать приложение
./scripts/build_macos.sh
```

## 🔧 Дополнительные настройки

### CORS настройки на сервере
Убедитесь, что на сервере настроены CORS заголовки:
```javascript
// Express.js пример
app.use(cors({
  origin: '*',
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'X-Request-With'],
  credentials: true
}));
```

### Настройка Railway
1. Проверить переменные окружения
2. Убедиться, что сервер запускается на правильном порту
3. Проверить логи в Railway Dashboard

## 🚀 Рекомендации

1. **Для разработки:** Используйте `development` окружение с локальным сервером
2. **Для тестирования:** Используйте `staging` окружение
3. **Для продакшна:** Используйте `production` окружение только когда сервер работает
4. **Всегда тестируйте** API перед сборкой приложения

## 📞 Поддержка

При возникновении проблем:
1. Проверьте статус сервера
2. Запустите тест API: `dart scripts/test_api.dart`
3. Проверьте логи сервера
4. Убедитесь, что CORS настроен правильно

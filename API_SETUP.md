# 🔧 Настройка API и решение проблем CORS

## 📋 Текущий статус

- ✅ **CORS настройки исправлены** в клиенте
- ✅ **Поддержка override API URL через dart-define** (`API_BASE_URL`)
- 🔄 **Продакшн теперь на VDS (Selectel)** — используйте домен `api.<домен>` + HTTPS

## 🚨 Проблемы и решения

### 1. CORS ошибки
**Проблема:** Браузер блокирует запросы из-за CORS политики

**Решение:** ✅ Исправлено
- Добавлены CORS заголовки в `DioClient`
- Создан `CorsInterceptor` для обработки preflight запросов
- Добавлен `ErrorHandlingInterceptor` для лучшей обработки ошибок

### 2. Продакшн на VDS (Selectel) — HTTPS и домен
Рекомендуется поднять `api.<домен>` на VDS (Nginx + Let’s Encrypt) и звать API по HTTPS.
Коротко:
1. A‑запись `api.<домен>` → ваш VDS IP (например `188.68.220.206`)
2. Nginx reverse proxy на ваш backend (например `127.0.0.1:3000`)
3. `certbot --nginx -d api.<домен> --redirect` для бесплатного сертификата

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

### Override через переменную сборки (рекомендовано)
Вы можете переопределить базовый URL без изменения кода:
```bash
# Пример локально (web)
flutter run -d chrome --dart-define=API_BASE_URL=http://127.0.0.1:3000/api/

# Пример прод-сборки web
flutter build web --release --web-renderer html \
  --dart-define=API_BASE_URL=https://api.<домен>/api/
```

## 🧪 Тестирование API

### Автоматическое тестирование
```bash
dart scripts/test_api.dart
```

### Ручное тестирование
```bash
# Тест продакшн сервера (VDS)
curl -I https://api.<домен>/api/

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
curl -I https://api.<домен>/api/

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

### Настройка VDS (Selectel)
1. Прописать DNS A‑запись для `api.<домен>` на IP VDS
2. Настроить Nginx reverse proxy на порт backend (например `127.0.0.1:3000`)
3. Выпустить сертификат Let’s Encrypt через `certbot --nginx`
4. Разрешить CORS для фронтенд домена (например `https://fastselect.ru`)

### GitHub Actions (Reg.ru деплой)
Workflow поддерживает секрет `PROD_API_BASE_URL`.
Если задать его в Settings → Secrets and variables → Actions → New repository secret,
то сборка web будет выполняться с `--dart-define=API_BASE_URL=$PROD_API_BASE_URL`.

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

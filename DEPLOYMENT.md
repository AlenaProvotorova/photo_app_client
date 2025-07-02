# 🚀 Руководство по развертыванию Photo App

## 📋 Обзор

Это руководство поможет вам развернуть Flutter приложение Photo App в продакшене с минимальными финансовыми затратами.

## 🎯 Архитектура развертывания

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Flutter App   │    │   NestJS API    │    │   PostgreSQL    │
│                 │    │                 │    │                 │
│ • Web (Vercel)  │◄──►│ • Railway       │◄──►│ • Railway       │
│ • Mobile        │    │ • $5/month      │    │ • Включена      │
│ • Desktop       │    └─────────────────┘    └─────────────────┘
└─────────────────┘
```

## 💰 Стоимость

- **Бэкенд + БД**: $5/месяц (Railway)
- **Веб-хостинг**: $0/месяц (Vercel)
- **Файловое хранилище**: $0-10/месяц (Cloudinary)
- **Итого**: $5-15/месяц

## 🛠️ Пошаговое развертывание

### 1. Подготовка репозитория

1. Убедитесь, что ваш код находится в GitHub репозитории
2. Настройте ветки: `main` (продакшен), `develop` (разработка)
3. Добавьте секреты в GitHub Settings → Secrets and variables → Actions

### 2. Настройка бэкенда (Railway)

1. Зарегистрируйтесь на [Railway](https://railway.app)
2. Создайте новый проект
3. Подключите ваш GitHub репозиторий
4. Настройте переменные окружения:

```env
NODE_ENV=production
DATABASE_URL=postgresql://...
JWT_SECRET=your-super-secret-jwt-key
CORS_ORIGIN=https://your-app.vercel.app
```

5. Добавьте PostgreSQL базу данных
6. Настройте кастомный домен (опционально)

### 3. Настройка веб-версии (Vercel)

1. Зарегистрируйтесь на [Vercel](https://vercel.com)
2. Подключите ваш GitHub репозиторий
3. Настройте переменные окружения:

```env
API_BASE_URL=https://your-api.railway.app/api/
IS_PRODUCTION=true
ENABLE_LOGGING=false
ENABLE_ANALYTICS=true
```

4. Настройте кастомный домен

### 4. Настройка файлового хранилища (Cloudinary)

1. Зарегистрируйтесь на [Cloudinary](https://cloudinary.com)
2. Получите API ключи
3. Добавьте в переменные окружения бэкенда:

```env
CLOUDINARY_CLOUD_NAME=your-cloud-name
CLOUDINARY_API_KEY=your-api-key
CLOUDINARY_API_SECRET=your-api-secret
```

### 5. Настройка мобильных приложений

#### Android

1. Создайте keystore для подписи:
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

2. Добавьте keystore в GitHub Secrets:
   - `KEYSTORE_PATH`: путь к keystore
   - `KEY_ALIAS`: alias ключа
   - `KEY_PASSWORD`: пароль ключа
   - `STORE_PASSWORD`: пароль хранилища

3. Настройте Google Play Console:
   - Создайте аккаунт разработчика ($25)
   - Создайте приложение
   - Загрузите APK через GitHub Actions

#### iOS

1. Настройте Apple Developer Program ($99/год)
2. Создайте сертификаты и профили
3. Настройте App Store Connect
4. Загрузите приложение через TestFlight

### 6. Настройка десктоп приложений

1. Соберите приложения локально:
```bash
# Windows
flutter build windows --release

# macOS
flutter build macos --release

# Linux
flutter build linux --release
```

2. Загрузите на GitHub Releases

## 🔧 Конфигурация

### Переменные окружения

#### Бэкенд (Railway)
```env
NODE_ENV=production
DATABASE_URL=postgresql://...
JWT_SECRET=your-super-secret-jwt-key
CORS_ORIGIN=https://your-app.vercel.app
CLOUDINARY_CLOUD_NAME=your-cloud-name
CLOUDINARY_API_KEY=your-api-key
CLOUDINARY_API_SECRET=your-api-secret
```

#### Фронтенд (Vercel)
```env
API_BASE_URL=https://your-api.railway.app/api/
IS_PRODUCTION=true
ENABLE_LOGGING=false
ENABLE_ANALYTICS=true
STORAGE_BASE_URL=https://res.cloudinary.com/your-cloud-name
```

### GitHub Secrets

Добавьте следующие секреты в GitHub Settings → Secrets:

- `API_BASE_URL`: URL вашего API
- `VERCEL_TOKEN`: токен Vercel
- `VERCEL_ORG_ID`: ID организации Vercel
- `VERCEL_PROJECT_ID`: ID проекта Vercel
- `KEYSTORE_PATH`: путь к Android keystore
- `KEY_ALIAS`: alias Android ключа
- `KEY_PASSWORD`: пароль Android ключа
- `STORE_PASSWORD`: пароль Android хранилища

## 🚀 Команды для развертывания

### Локальная разработка
```bash
# Запуск с Docker
docker-compose up -d

# Запуск Flutter приложения
flutter run -d chrome --web-port 8080
```

### Продакшен сборка
```bash
# Веб
flutter build web --release --dart-define=API_BASE_URL=https://your-api.railway.app/api/

# Android
flutter build apk --release --dart-define=API_BASE_URL=https://your-api.railway.app/api/

# iOS
flutter build ios --release --dart-define=API_BASE_URL=https://your-api.railway.app/api/

# Desktop
flutter build windows --release --dart-define=API_BASE_URL=https://your-api.railway.app/api/
```

## 📊 Мониторинг

### Логи
- Railway: встроенные логи в дашборде
- Vercel: встроенные логи в дашборде
- GitHub Actions: логи в репозитории

### Аналитика
- Firebase Analytics (бесплатно)
- Sentry для отслеживания ошибок (бесплатно до 5000 ошибок/месяц)

## 🔒 Безопасность

1. Используйте HTTPS везде
2. Настройте CORS правильно
3. Используйте сильные JWT секреты
4. Регулярно обновляйте зависимости
5. Настройте rate limiting на API

## 📈 Масштабирование

### Когда нужно масштабировать:
- > 1000 активных пользователей
- > 10GB данных
- > 100GB трафика/месяц

### Варианты масштабирования:
1. **Railway**: автоматическое масштабирование
2. **DigitalOcean**: больше контроля, $12-24/месяц
3. **AWS**: максимальная гибкость, $50-200/месяц

## 🆘 Устранение неполадок

### Частые проблемы:

1. **CORS ошибки**: проверьте настройки CORS в бэкенде
2. **Проблемы с базой данных**: проверьте DATABASE_URL
3. **Проблемы с загрузкой файлов**: проверьте настройки Cloudinary
4. **Проблемы с аутентификацией**: проверьте JWT_SECRET

### Полезные команды:
```bash
# Проверка статуса Railway
railway status

# Просмотр логов Railway
railway logs

# Проверка статуса Vercel
vercel ls
```

## 📞 Поддержка

- Railway: [docs.railway.app](https://docs.railway.app)
- Vercel: [vercel.com/docs](https://vercel.com/docs)
- Flutter: [flutter.dev/docs](https://flutter.dev/docs)
- NestJS: [docs.nestjs.com](https://docs.nestjs.com) 
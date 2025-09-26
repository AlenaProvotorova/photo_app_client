# 🚀 **Подробный план развертывания Flutter приложения на Reg.ru**

## **Этап 1: Подготовка домена и хостинга на Reg.ru**

### 1.1 Регистрация домена
1. **Перейти на [reg.ru](https://reg.ru)**
2. **Выбрать и зарегистрировать домен:**
   - Ввести желаемое имя домена
   - Выбрать зону (.ru, .com, .рф и т.д.)
   - Проверить доступность
   - Добавить в корзину и оплатить

### 1.2 Настройка хостинга
1. **Выбрать тариф хостинга:**
   - **Минимальный**: для статических сайтов (ваш случай)
   - **Рекомендуемый**: "Хостинг для сайтов" - от 99₽/месяц
2. **Привязать домен к хостингу:**
   - В панели управления Reg.ru
   - Раздел "Хостинг" → "Добавить домен"
   - Указать зарегистрированный домен

## **Этап 2: Подготовка Flutter приложения для веб-развертывания**

### 2.1 Обновление конфигурации приложения
```bash
# 1. Обновить метаданные в web/index.html
```

**Обновить `web/index.html`:**
```html
<!DOCTYPE html>
<html>
<head>
  <base href="/">
  <meta charset="UTF-8">
  <meta content="IE=Edge" http-equiv="X-UA-Compatible">
  <meta name="description" content="Photo App - Управление фотографиями">
  <meta name="keywords" content="фото, приложение, управление">
  <meta name="author" content="Your Name">
  
  <!-- iOS meta tags & icons -->
  <meta name="apple-mobile-web-app-capable" content="yes">
  <meta name="apple-mobile-web-app-status-bar-style" content="black">
  <meta name="apple-mobile-web-app-title" content="Photo App">
  <link rel="apple-touch-icon" href="icons/Icon-192.png">

  <!-- Favicon -->
  <link rel="icon" type="image/png" href="favicon.png"/>

  <title>Photo App</title>
  <link rel="manifest" href="manifest.json">
</head>
<body>
  <script src="flutter_bootstrap.js" async></script>
</body>
</html>
```

**Обновить `web/manifest.json`:**
```json
{
    "name": "Photo App",
    "short_name": "PhotoApp",
    "start_url": ".",
    "display": "standalone",
    "background_color": "#0175C2",
    "theme_color": "#0175C2",
    "description": "Приложение для управления фотографиями",
    "orientation": "portrait-primary",
    "prefer_related_applications": false,
    "icons": [
        {
            "src": "icons/Icon-192.png",
            "sizes": "192x192",
            "type": "image/png"
        },
        {
            "src": "icons/Icon-512.png",
            "sizes": "512x512",
            "type": "image/png"
        },
        {
            "src": "icons/Icon-maskable-192.png",
            "sizes": "192x192",
            "type": "image/png",
            "purpose": "maskable"
        },
        {
            "src": "icons/Icon-maskable-512.png",
            "sizes": "512x512",
            "type": "image/png",
            "purpose": "maskable"
        }
    ]
}
```

### 2.2 Сборка приложения для веб
```bash
# 1. Очистить предыдущую сборку
flutter clean

# 2. Получить зависимости
flutter pub get

# 3. Собрать веб-версию
flutter build web --release

# 4. Проверить сборку локально
flutter run -d chrome --web-port 8080
```

## **Этап 3: Настройка файлов для Reg.ru**

### 3.1 Создание файла .htaccess
Создать файл `build/web/.htaccess`:
```apache
# Включить сжатие
<IfModule mod_deflate.c>
    AddOutputFilterByType DEFLATE text/plain
    AddOutputFilterByType DEFLATE text/html
    AddOutputFilterByType DEFLATE text/xml
    AddOutputFilterByType DEFLATE text/css
    AddOutputFilterByType DEFLATE application/xml
    AddOutputFilterByType DEFLATE application/xhtml+xml
    AddOutputFilterByType DEFLATE application/rss+xml
    AddOutputFilterByType DEFLATE application/javascript
    AddOutputFilterByType DEFLATE application/x-javascript
</IfModule>

# Кэширование
<IfModule mod_expires.c>
    ExpiresActive on
    ExpiresByType text/css "access plus 1 year"
    ExpiresByType application/javascript "access plus 1 year"
    ExpiresByType image/png "access plus 1 year"
    ExpiresByType image/jpg "access plus 1 year"
    ExpiresByType image/jpeg "access plus 1 year"
    ExpiresByType image/gif "access plus 1 year"
    ExpiresByType image/svg+xml "access plus 1 year"
</IfModule>

# SPA routing
RewriteEngine On
RewriteBase /
RewriteRule ^index\.html$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.html [L]
```

### 3.2 Создание robots.txt
Создать файл `build/web/robots.txt`:
```txt
User-agent: *
Allow: /

Sitemap: https://yourdomain.ru/sitemap.xml
```

## **Этап 4: Загрузка файлов на Reg.ru**

### 4.1 Подключение к хостингу
1. **Получить данные FTP:**
   - В панели Reg.ru → "Хостинг" → "Управление"
   - Найти данные FTP: хост, логин, пароль, порт

2. **Подключиться через FTP-клиент:**
   - **Рекомендуемые**: FileZilla, WinSCP, Cyberduck
   - **Настройки подключения:**
     - Хост: `ftp.yourdomain.ru` или IP-адрес
     - Порт: `21` (обычно)
     - Протокол: `FTP`
     - Логин: ваш логин хостинга
     - Пароль: пароль хостинга

### 4.2 Загрузка файлов
1. **Подключиться к FTP**
2. **Перейти в папку `public_html`** (корневая папка сайта)
3. **Очистить содержимое** (если есть)
4. **Загрузить все файлы из `build/web/`:**
   ```
   public_html/
   ├── index.html
   ├── flutter_bootstrap.js
   ├── main.dart.js
   ├── flutter.js
   ├── icons/
   ├── assets/
   ├── .htaccess
   ├── robots.txt
   └── manifest.json
   ```

## **Этап 5: Настройка DNS и SSL**

### 5.1 Настройка DNS
1. **В панели Reg.ru:**
   - "Домены" → "Управление DNS"
   - Убедиться, что A-запись указывает на IP хостинга
   - Добавить CNAME для www (если нужно)

### 5.2 Настройка SSL-сертификата
1. **В панели хостинга:**
   - "SSL-сертификаты" → "Заказать"
   - Выбрать "Let's Encrypt" (бесплатно)
   - Активировать для домена
   - Принудительное перенаправление на HTTPS

## **Этап 6: Тестирование и оптимизация**

### 6.1 Проверка работы сайта
1. **Открыть сайт в браузере:**
   - `https://yourdomain.ru`
   - `https://www.yourdomain.ru`

2. **Проверить функциональность:**
   - Загрузка приложения
   - Работа всех функций
   - Адаптивность на мобильных

### 6.2 Оптимизация производительности
1. **Проверить скорость загрузки:**
   - [PageSpeed Insights](https://pagespeed.web.dev/)
   - [GTmetrix](https://gtmetrix.com/)

2. **Настроить кэширование** (уже в .htaccess)

## **Этап 7: Мониторинг и поддержка**

### 7.1 Настройка аналитики
1. **Google Analytics:**
   - Добавить код отслеживания в `web/index.html`
   - Настроить цели и события

2. **Яндекс.Метрика:**
   - Добавить код счетчика
   - Настроить вебвизор

### 7.2 Резервное копирование
1. **Автоматические бэкапы** (если доступно в тарифе)
2. **Ручное копирование** файлов перед обновлениями

## **📋 Чеклист развертывания**

- [ ] Домен зарегистрирован на Reg.ru
- [ ] Хостинг подключен к домену
- [ ] Flutter приложение собрано для веб
- [ ] Файлы .htaccess и robots.txt созданы
- [ ] Все файлы загружены в public_html
- [ ] DNS настроен корректно
- [ ] SSL-сертификат установлен
- [ ] Сайт открывается по HTTPS
- [ ] Все функции приложения работают
- [ ] Аналитика настроена
- [ ] Скорость загрузки проверена

## **🔄 Процесс обновления приложения**

```bash
# 1. Внести изменения в код
# 2. Собрать новую версию
flutter build web --release

# 3. Загрузить обновленные файлы на хостинг
# 4. Проверить работу обновленной версии
```

## **💰 Примерная стоимость на Reg.ru**

- **Домен .ru**: от 199₽/год
- **Хостинг "Сайты"**: от 99₽/месяц
- **SSL-сертификат**: бесплатно (Let's Encrypt)
- **Итого**: ~1400₽/год

Этот план обеспечит надежное развертывание вашего Flutter приложения на Reg.ru с минимальными затратами и максимальной производительностью!

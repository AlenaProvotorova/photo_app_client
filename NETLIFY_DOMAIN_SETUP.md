# 🌐 Настройка кастомного домена в Netlify

## 📋 Пошаговая инструкция

### 1. Подготовка домена

#### 1.1 Регистрация домена
- Зарегистрируйте домен на любом регистраторе (Reg.ru, GoDaddy, Namecheap и т.д.)
- **Рекомендуемые зоны**: .com, .ru, .org, .net

#### 1.2 Получение DNS данных
- Запишите DNS серверы вашего регистратора
- Обычно это что-то вроде: `ns1.reg.ru`, `ns2.reg.ru`

### 2. Настройка в Netlify

#### 2.1 Подключение к GitHub
1. Войдите в [Netlify](https://netlify.com)
2. Нажмите "New site from Git"
3. Выберите "GitHub" и авторизуйтесь
4. Выберите ваш репозиторий `photo_app_client`
5. Настройки сборки:
   - **Build command**: `./build_web.sh`
   - **Publish directory**: `build/web`
6. Нажмите "Deploy site"

#### 2.2 Добавление кастомного домена
1. В панели Netlify перейдите в **Site settings**
2. Выберите **Domain management**
3. Нажмите **Add custom domain**
4. Введите ваш домен (например: `yourdomain.com`)
5. Нажмите **Verify**

### 3. Настройка DNS записей

#### 3.1 В панели Netlify
После добавления домена Netlify покажет необходимые DNS записи:

```
Type: A
Name: @
Value: 75.2.60.5

Type: CNAME  
Name: www
Value: yoursite.netlify.app
```

#### 3.2 В панели регистратора домена
1. Войдите в панель управления доменом
2. Найдите раздел "DNS" или "Управление DNS"
3. Добавьте записи:

**Для корневого домена (yourdomain.com):**
```
Тип: A
Имя: @ (или оставить пустым)
Значение: 75.2.60.5
TTL: 3600
```

**Для www поддомена:**
```
Тип: CNAME
Имя: www
Значение: yoursite.netlify.app
TTL: 3600
```

### 4. Настройка SSL-сертификата

#### 4.1 Автоматическая настройка
1. В Netlify перейдите в **Site settings** → **Domain management**
2. Нажмите **Verify DNS configuration**
3. Дождитесь проверки DNS (может занять до 24 часов)
4. Netlify автоматически выдаст SSL-сертификат

#### 4.2 Принудительное HTTPS
1. В **Site settings** → **Domain management**
2. Включите **Force HTTPS**
3. Включите **Redirect to HTTPS**

### 5. Проверка работы

#### 5.1 Тестирование домена
```bash
# Проверка DNS
nslookup yourdomain.com
nslookup www.yourdomain.com

# Проверка доступности
curl -I https://yourdomain.com
curl -I https://www.yourdomain.com
```

#### 5.2 Проверка в браузере
- Откройте `https://yourdomain.com`
- Убедитесь, что сайт загружается
- Проверьте, что есть зеленый замок (SSL)
- Протестируйте все функции приложения

### 6. Автоматический деплой

#### 6.1 Настройка GitHub Actions (опционально)
Создайте файл `.github/workflows/deploy.yml`:

```yaml
name: Deploy to Netlify
on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.6.0'
        
    - name: Install dependencies
      run: flutter pub get
      
    - name: Build web
      run: ./build_web.sh
      
    - name: Deploy to Netlify
      uses: nwtgck/actions-netlify@v2.0
      with:
        publish-dir: './build/web'
        production-branch: main
        github-token: ${{ secrets.GITHUB_TOKEN }}
        deploy-message: "Deploy from GitHub Actions"
      env:
        NETLIFY_AUTH_TOKEN: ${{ secrets.NETLIFY_AUTH_TOKEN }}
        NETLIFY_SITE_ID: ${{ secrets.NETLIFY_SITE_ID }}
```

#### 6.2 Обычный деплой через Git
```bash
# 1. Внести изменения в код
# 2. Собрать приложение
./build_web.sh

# 3. Закоммитить изменения
git add .
git commit -m "Update app for production"

# 4. Запушить в GitHub
git push origin main

# 5. Netlify автоматически задеплоит
```

## 🔧 Устранение проблем

### Проблема: Домен не резолвится
**Решение:**
1. Проверьте DNS записи в панели регистратора
2. Подождите 24-48 часов для распространения DNS
3. Используйте `nslookup` для проверки

### Проблема: SSL-сертификат не выдается
**Решение:**
1. Убедитесь, что DNS записи настроены правильно
2. Проверьте, что домен доступен по HTTP
3. Обратитесь в поддержку Netlify

### Проблема: Сайт не обновляется после деплоя
**Решение:**
1. Очистите кэш браузера (Ctrl+F5)
2. Проверьте логи сборки в Netlify
3. Убедитесь, что все файлы закоммичены

## 📊 Мониторинг

### Аналитика Netlify
1. В панели Netlify → **Analytics**
2. Просмотр статистики посещений
3. Анализ производительности

### Внешние сервисы
- **Google Analytics**: добавьте код в `web/index.html`
- **Яндекс.Метрика**: добавьте счетчик
- **Hotjar**: для анализа поведения пользователей

## 💰 Стоимость

### Netlify (бесплатный план)
- ✅ 100GB трафика в месяц
- ✅ 300 минут сборки в месяц
- ✅ Кастомные домены
- ✅ SSL-сертификаты
- ✅ CDN по всему миру

### Дополнительные расходы
- **Домен**: от 199₽/год (.ru) до 1000₽/год (.com)
- **Дополнительный трафик**: $20/100GB (если превысите лимит)

## 🎯 Итоговая схема

```
GitHub Repository
       ↓ (автоматический деплой)
   Netlify CDN
       ↓ (кастомный домен)
   yourdomain.com
       ↓ (SSL-сертификат)
   https://yourdomain.com
```

## 📞 Поддержка

- **Netlify Support**: [support.netlify.com](https://support.netlify.com)
- **Документация**: [docs.netlify.com](https://docs.netlify.com)
- **Сообщество**: [community.netlify.com](https://community.netlify.com)

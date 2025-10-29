# 🚀 Настройка автоматического деплоя на Reg.ru из GitHub

## Обзор

Этот проект настроен для автоматического деплоя Flutter веб-приложения на Reg.ru хостинг при каждом пуше в ветку `main` (или `master`).

## ⚙️ Настройка (один раз)

### Шаг 1: Получите FTP данные из Reg.ru (ISPmanager)

**Для панели ISPmanager (как у вас):**

1. В **левом меню** найдите и нажмите **"FTP-пользователи"** (FTP Users)
2. Если FTP-пользователя нет - создайте нового:
   - Имя: например, `deploy` или `fastselect_deploy`
   - Пароль: придумайте надежный
   - Домашняя директория: `/www/fastselect.ru`
3. Запишите данные:
   - **FTP-хост**: обычно `fastselect.ru` (без `ftp.`) или IP из списка сайтов
   - **FTP-логин**: имя пользователя из списка FTP-пользователей
   - **FTP-пароль**: пароль этого пользователя
   - **Порт**: обычно `21` (для FTP)

**Подробная инструкция:** см. файл `ISP_MANAGER_FTP_GUIDE.md`

### Шаг 2: Добавьте секреты в GitHub

1. Откройте ваш репозиторий на GitHub
2. Перейдите: **Settings** → **Secrets and variables** → **Actions**
3. Нажмите **New repository secret**
4. Добавьте следующие секреты:

#### `REG_RU_FTP_HOST`
- **Значение**: `ftp.fastselect.ru` или IP-адрес FTP сервера
- **Пример**: `ftp.fastselect.ru` или `123.456.789.0`

#### `REG_RU_FTP_USER`
- **Значение**: ваш FTP логин из Reg.ru
- **Пример**: `u123456789`

#### `REG_RU_FTP_PASSWORD`
- **Значение**: ваш FTP пароль из Reg.ru
- **Пример**: `ваш_пароль`

### Шаг 3: Настройте ветку для деплоя (опционально)

По умолчанию деплой запускается при пуше в `main`. Если используете другую ветку:

1. Откройте `.github/workflows/deploy_to_regru.yml`
2. Измените ветки в секции `on.push.branches`:
   ```yaml
   branches:
     - ваша_ветка
   ```

### Шаг 4: Первый деплой

1. Сделайте коммит и пуш в ветку `main`:
   ```bash
   git add .
   git commit -m "Setup auto-deploy to Reg.ru"
   git push origin main
   ```

2. Проверьте статус деплоя:
   - Откройте GitHub → **Actions** вкладка
   - Найдите запущенный workflow
   - Дождитесь завершения (обычно 5-10 минут)

3. Проверьте сайт:
   - Откройте https://fastselect.ru
   - Убедитесь, что изменения применились

## 🔄 Как работает автоматический деплой

### Когда запускается:
- ✅ При каждом пуше в ветку `main` (или `master`)
- ✅ При ручном запуске через GitHub Actions UI

### Что происходит:
1. **Checkout кода** - загружается код из репозитория
2. **Настройка Flutter** - устанавливается Flutter 3.27.0
3. **Установка зависимостей** - `flutter pub get`
4. **Сборка** - `flutter build web --release --web-renderer html`
5. **Создание .htaccess** - добавляется файл для Reg.ru
6. **Деплой через FTP** - файлы загружаются в `public_html` на Reg.ru

### Время деплоя:
- Первая сборка: ~8-10 минут
- Последующие: ~5-7 минут (с кэшем)

## 📝 Ручной запуск деплоя

Если нужно задеплоить без коммита:

1. Откройте GitHub → **Actions**
2. Выберите workflow **Deploy to Reg.ru**
3. Нажмите **Run workflow**
4. Выберите ветку и нажмите **Run workflow**

## 🛠️ Настройка для SFTP (если требуется)

Если Reg.ru требует SFTP (порт 22), измените workflow:

1. Откройте `.github/workflows/deploy_to_regru.yml`
2. Найдите секцию `Deploy to Reg.ru via FTP`
3. Замените на:

```yaml
- name: Deploy to Reg.ru via SFTP
  uses: SamKirkland/FTP-Deploy-Action@v4.3.5
  with:
    server: ${{ secrets.REG_RU_FTP_HOST }}
    username: ${{ secrets.REG_RU_FTP_USER }}
    password: ${{ secrets.REG_RU_FTP_PASSWORD }}
    protocol: ftps  # или sftp
    port: 22  # или 21 для обычного FTP
    local-dir: ./build/web/
    server-dir: ./public_html/
```

## 🔒 Безопасность

- ✅ Секреты хранятся зашифрованными в GitHub
- ✅ Пароли никогда не отображаются в логах
- ✅ Доступ к секретам только у администраторов репозитория

## ❗ Возможные проблемы

### Ошибка: "Connection refused"
- **Причина**: Неверный FTP-хост или порт
- **Решение**: Проверьте FTP данные в Reg.ru

### Ошибка: "Authentication failed"
- **Причина**: Неверный логин или пароль
- **Решение**: Обновите секреты в GitHub

### Ошибка: "Directory not found"
- **Причина**: Неверный `server-dir`
- **Решение**: Для ISPmanager путь должен быть `/www/fastselect.ru/` (не `public_html`)

### Деплой работает, но сайт не обновляется
- **Причина**: Кэш браузера или Reg.ru
- **Решение**: 
  1. Проверьте, что файлы загрузились (через FTP)
  2. Очистите кэш в браузере
  3. Попробуйте открыть в режиме инкогнито

## 📋 Чеклист настройки

- [ ] Получены FTP данные из Reg.ru
- [ ] Добавлены секреты `REG_RU_FTP_HOST` в GitHub
- [ ] Добавлены секреты `REG_RU_FTP_USER` в GitHub
- [ ] Добавлены секреты `REG_RU_FTP_PASSWORD` в GitHub
- [ ] Проверена ветка для деплоя в workflow
- [ ] Сделан первый коммит и пуш
- [ ] Проверен статус в GitHub Actions
- [ ] Проверена работа сайта после деплоя

## 🔗 Полезные ссылки

- [GitHub Actions документация](https://docs.github.com/en/actions)
- [FTP Deploy Action](https://github.com/SamKirkland/FTP-Deploy-Action)
- [Reg.ru хостинг](https://www.reg.ru)

---

После настройки каждый коммит в `main` будет автоматически деплоиться на Reg.ru! 🎉


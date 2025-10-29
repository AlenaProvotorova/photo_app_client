# 🔧 Исправление ошибки "Timeout (control socket)" при деплое

## Проблема

Ошибка подключения к FTP-серверу. Возможные причины:
1. Сервер требует **SFTP** (порт 22), а не FTP (порт 21)
2. Сервер требует **FTPS** (защищенный FTP, порт 990)
3. Неверный FTP-хост
4. Сервер блокирует подключения из GitHub Actions

## Решения по порядку

### Решение 1: Использовать FTPS (попробуйте первым)

Обновленный workflow уже настроен на FTPS. Если не сработает - попробуйте другие варианты.

### Решение 2: Проверьте FTP-хост в ISPmanager

В панели ISPmanager:

1. Перейдите: **"FTP-пользователи"** → выберите вашего пользователя
2. Проверьте, какой **хост** указан
3. Попробуйте использовать **IP-адрес** вместо домена:
   - Из скриншота: `31.31.197.50`
   - Обновите секрет `REG_RU_FTP_HOST` в GitHub на IP-адрес

### Решение 3: Измените протокол на SFTP

Если Reg.ru/ISPmanager требует SFTP, обновите workflow:

```yaml
- name: Deploy to Reg.ru via SFTP
  uses: SamKirkland/FTP-Deploy-Action@v4.3.5
  with:
    server: ${{ secrets.REG_RU_FTP_HOST }}
    username: ${{ secrets.REG_RU_FTP_USER }}
    password: ${{ secrets.REG_RU_FTP_PASSWORD }}
    protocol: sftp
    port: 22
    local-dir: ./build/web/
    server-dir: /www/fastselect.ru/  # Обратите внимание на / в начале
```

### Решение 4: Используйте lftp через SSH (альтернатива)

Если FTP/SFTP не работает, можно использовать другой способ деплоя. Но сначала попробуйте решения выше.

### Решение 5: Проверьте путь server-dir

Убедитесь, что путь правильный:
- ✅ `./www/fastselect.ru/` (относительный)
- ✅ `/www/fastselect.ru/` (абсолютный с `/`)
- ❌ `www/fastselect.ru/` (без точки и слеша)

## Пошаговая проверка

### Шаг 1: Проверьте FTP данные в ISPmanager

1. **FTP-хост**: Запишите точное значение
   - Может быть: `fastselect.ru`, `ftp.fastselect.ru`, или IP `31.31.197.50`
   
2. **Порт**: Проверьте, какой порт указан
   - `21` - обычный FTP
   - `22` - SFTP
   - `990` - FTPS

3. **Протокол**: Узнайте, какой протокол поддерживается
   - Попробуйте подключиться через FileZilla с разными протоколами

### Шаг 2: Протестируйте подключение локально

Используйте FTP-клиент (FileZilla, WinSCP) для проверки:

**Настройки для FileZilla:**
- Хост: `fastselect.ru` (или IP)
- Порт: `21` (или `22` для SFTP)
- Протокол: FTP/FTPS или SFTP
- Логин: ваш FTP-логин
- Пароль: ваш FTP-пароль

Если подключение работает локально - проблема в настройках GitHub Actions.

### Шаг 3: Обновите секреты в GitHub

После проверки, обновите секрет `REG_RU_FTP_HOST`:
- Если локально работает с IP - используйте IP
- Если работает с доменом - используйте домен

### Шаг 4: Попробуйте разные варианты протокола

В workflow попробуйте по очереди:

**Вариант A: FTPS (защищенный FTP)**
```yaml
protocol: ftps
port: 21
```

**Вариант B: SFTP**
```yaml
protocol: sftp
port: 22
```

**Вариант C: Обычный FTP**
```yaml
protocol: ftp
port: 21
```

## Быстрое решение (попробуйте первым)

1. **Измените `REG_RU_FTP_HOST` на IP-адрес:**
   - В GitHub Secrets замените `fastselect.ru` на `31.31.197.50`

2. **Если не помогло - попробуйте изменить протокол:**
   - В `.github/workflows/deploy_to_regru.yml` измените `protocol: ftps` на `protocol: sftp`
   - И `port: 21` на `port: 22`

3. **Проверьте путь:**
   - Убедитесь, что в ISPmanager домашняя директория FTP-пользователя: `/www/fastselect.ru`

## Альтернатива: Использовать другой action

Если FTP-Deploy-Action не работает, можно использовать другой способ:

```yaml
- name: Deploy via rsync over SSH
  uses: burnett01/rsync-deployments@7.0.0
  with:
    switches: -avzr --delete
    path: ./build/web/
    remote_path: /www/fastselect.ru/
    remote_host: ${{ secrets.REG_RU_FTP_HOST }}
    remote_user: ${{ secrets.REG_RU_FTP_USER }}
    remote_key: ${{ secrets.REG_RU_SSH_KEY }}
```

Но для этого нужен SSH-ключ, а не пароль.

## Рекомендации

1. **Сначала попробуйте изменить хост на IP** (`31.31.197.50`)
2. **Затем попробуйте разные протоколы** (FTPS, SFTP)
3. **Проверьте путь** в ISPmanager
4. Если ничего не помогает - свяжитесь с поддержкой Reg.ru и спросите:
   - Какой протокол для FTP-доступа: FTP, FTPS или SFTP?
   - Какой порт использовать?
   - Нужен ли специальный хост для FTP?

---

**Следующие шаги:**
1. Проверьте FTP данные в ISPmanager
2. Протестируйте подключение локально через FileZilla
3. Обновите секреты и workflow
4. Перезапустите деплой


# 🪟 Сборка Windows приложения

## Быстрый старт

### 1. Обычная сборка
```bash
./scripts/quick_build.sh
```

### 2. Создание релиза
```bash
./scripts/quick_build.sh --release
```

### 3. Сборка с сообщением коммита
```bash
./scripts/build_windows_github.sh "Добавлена новая функция"
```

## 📋 Подробные инструкции

### Подготовка

1. **Убедитесь, что проект настроен:**
   ```bash
   # Проверьте git репозиторий
   git remote -v
   
   # Проверьте версию в pubspec.yaml
   grep "version:" pubspec.yaml
   ```

2. **Настройте GitHub репозиторий (если еще не настроен):**
   ```bash
   git remote add origin https://github.com/yourusername/photo_app_client.git
   ```

### Сборка

#### Вариант 1: Быстрая сборка
```bash
# Обычная сборка
./scripts/quick_build.sh

# Создание релиза
./scripts/quick_build.sh --release
```

#### Вариант 2: Детальная сборка
```bash
# Сборка с кастомным сообщением
./scripts/build_windows_github.sh "Описание изменений"

# Создание релиза
./scripts/create_release.sh
```

### Результат

После успешной сборки:

1. **Артефакты** будут доступны в разделе Actions
2. **Релизы** будут созданы автоматически (при использовании `--release`)
3. **ZIP файл** можно скачать и установить на Windows

## 🔧 Настройка

### GitHub Actions

Workflow настроен в `.github/workflows/build-windows.yml` и включает:

- ✅ Автоматическую сборку при push в main/master
- ✅ Сборку при создании тегов (v*)
- ✅ Ручной запуск через GitHub UI
- ✅ Создание ZIP архива
- ✅ Автоматическое создание релизов
- ✅ Загрузку артефактов
- ✅ Покрытие тестами

### Скрипты

| Скрипт | Описание |
|--------|----------|
| `quick_build.sh` | Быстрый запуск сборки или релиза |
| `build_windows_github.sh` | Детальная сборка через GitHub Actions |
| `create_release.sh` | Создание релиза с тегом |
| `build_windows.bat` | Сборка на Windows машине (если доступна) |

## 📦 Установка на Windows

### Автоматическая установка

1. Скачайте ZIP файл из релизов
2. Распакуйте в папку (например, `C:\Program Files\PhotoApp\`)
3. Запустите `photo_app_client.exe`

### Создание ярлыка

```powershell
# Создайте ярлык на рабочем столе
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\PhotoApp.lnk")
$Shortcut.TargetPath = "C:\Program Files\PhotoApp\photo_app_client.exe"
$Shortcut.Save()
```

## 🐛 Решение проблем

### Ошибки сборки

1. **"build windows only supported on Windows hosts"**
   - Используйте GitHub Actions (скрипты выше)

2. **Ошибки с плагинами**
   ```bash
   flutter clean
   flutter pub get
   flutter upgrade
   ```

3. **Проблемы с зависимостями**
   - Проверьте `pubspec.yaml`
   - Убедитесь, что все плагины поддерживают Windows

### Проблемы с GitHub Actions

1. **Workflow не запускается**
   - Проверьте права доступа к репозиторию
   - Убедитесь, что файл `.github/workflows/build-windows.yml` в репозитории

2. **Ошибки при создании релиза**
   - Проверьте, что у репозитория есть права на создание релизов
   - Убедитесь, что тег создан правильно

### Логи и отладка

```bash
# Просмотр логов GitHub Actions (если установлен gh)
gh run list
gh run watch

# Локальная проверка
flutter doctor -v
flutter build windows --verbose
```

## 📊 Мониторинг

### GitHub Actions
- **Статус:** https://github.com/yourusername/photo_app_client/actions
- **Релизы:** https://github.com/yourusername/photo_app_client/releases

### Уведомления
- Настройте уведомления GitHub для отслеживания сборок
- Используйте GitHub CLI для мониторинга: `gh run watch`

## 🚀 Автоматизация

### CI/CD Pipeline

1. **Push в main** → автоматическая сборка
2. **Создание тега** → автоматический релиз
3. **Pull Request** → проверка сборки

### Настройка уведомлений

```yaml
# В .github/workflows/build-windows.yml добавьте:
- name: Notify on success
  if: success()
  run: |
    # Отправка уведомления в Slack/Discord/Email
```

## 📈 Оптимизация

### Размер приложения

```bash
# Анализ размера
flutter build windows --analyze-size

# Оптимизация
flutter build windows --release --tree-shake-icons
```

### Производительность

```bash
# Сборка с оптимизациями
flutter build windows --release --dart-define=FLUTTER_WEB_USE_SKIA=true
```

## 🔒 Безопасность

### Подписание кода

```bash
# Настройка подписания (на Windows)
flutter build windows --release --dart-define=ENABLE_CODE_SIGNING=true
```

### Антивирус

- Некоторые антивирусы могут блокировать .exe файлы
- Рассмотрите подписание кода для избежания ложных срабатываний

## 📞 Поддержка

При возникновении проблем:

1. Проверьте логи GitHub Actions
2. Убедитесь в совместимости плагинов
3. Обновите Flutter: `flutter upgrade`
4. Обратитесь к документации Flutter

---

**Готово!** Теперь у вас есть полная система сборки Windows приложения через GitHub Actions. 🎉

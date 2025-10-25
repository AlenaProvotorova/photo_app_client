# 📱 Руководство по релизу Photo App для macOS

## 🚀 Быстрый старт

### 1. Подготовка к сборке
```bash
# Остановить все запущенные процессы приложения
pkill -f photo_app

# Очистить заблокированные файлы Hive
rm -f ~/Library/Containers/com.example.photoApp/Data/Documents/*.lock

# Перейти в папку проекта
cd /path/to/photo_app_client
```

### 2. Создание релизной сборки
```bash
# Создать релизную сборку для macOS
flutter build macos --release
```

### 3. Создание архива для распространения
```bash
# Перейти в папку с релизной сборкой
cd build/macos/Build/Products/Release

# Создать архив
zip -r photo_app_macos_release.zip photo_app.app

# Переместить архив в корень проекта
mv photo_app_macos_release.zip ../../../../../
```

## 📋 Пошаговая инструкция

### Шаг 1: Проверка готовности
- [ ] Все изменения зафиксированы в git
- [ ] Код протестирован и работает корректно
- [ ] Нет активных процессов приложения

### Шаг 2: Очистка системы
```bash
# Остановить процессы
pkill -f photo_app

# Очистить файлы блокировки
rm -f ~/Library/Containers/com.example.photoApp/Data/Documents/*.lock
```

### Шаг 3: Сборка приложения
```bash
# Создать релизную сборку
flutter build macos --release
```

**Ожидаемый результат:**
```
✓ Built build/macos/Build/Products/Release/photo_app.app (61.3MB)
```

### Шаг 4: Создание архива
```bash
# Перейти в папку релиза
cd build/macos/Build/Products/Release

# Создать архив с версией
zip -r photo_app_macos_release_v$(date +%Y%m%d).zip photo_app.app

# Переместить в корень проекта
mv photo_app_macos_release_v*.zip ../../../../../
```

### Шаг 5: Тестирование
```bash
# Запустить релизную версию
open build/macos/Build/Products/Release/photo_app.app
```

## 🔧 Решение проблем

### Проблема: Ошибки блокировки файлов Hive
```bash
# Решение:
pkill -f photo_app
rm -f ~/Library/Containers/com.example.photoApp/Data/Documents/*.lock
flutter build macos --release
```

### Проблема: Приложение не запускается
```bash
# Проверить процессы
ps aux | grep photo_app

# Если процессы есть - остановить
pkill -f photo_app

# Запустить заново
open build/macos/Build/Products/Release/photo_app.app
```

### Проблема: Ошибки сборки
```bash
# Очистить кэш Flutter
flutter clean

# Получить зависимости заново
flutter pub get

# Пересобрать
flutter build macos --release
```

## 📁 Структура файлов после сборки

```
photo_app_client/
├── build/macos/Build/Products/Release/
│   └── photo_app.app                    # Готовое приложение
├── photo_app_macos_release_v20241023.zip # Архив для распространения
└── RELEASE_GUIDE.md                     # Эта инструкция
```

## ✅ Чек-лист релиза

- [ ] Код протестирован
- [ ] Все процессы остановлены
- [ ] Файлы блокировки очищены
- [ ] Релизная сборка создана
- [ ] Архив создан
- [ ] Приложение запускается
- [ ] Функциональность работает
- [ ] Архив готов к распространению

## 🎯 Автоматизация

### Скрипт для автоматической сборки
Создайте файл `build_release.sh`:

```bash
#!/bin/bash
echo "🚀 Начинаем сборку релиза..."

# Остановить процессы
echo "⏹️ Останавливаем процессы..."
pkill -f photo_app

# Очистить файлы блокировки
echo "🧹 Очищаем файлы блокировки..."
rm -f ~/Library/Containers/com.example.photoApp/Data/Documents/*.lock

# Создать сборку
echo "🔨 Создаем релизную сборку..."
flutter build macos --release

# Создать архив
echo "📦 Создаем архив..."
cd build/macos/Build/Products/Release
zip -r photo_app_macos_release_v$(date +%Y%m%d).zip photo_app.app
mv photo_app_macos_release_v*.zip ../../../../../

echo "✅ Релиз готов!"
echo "📁 Архив: photo_app_macos_release_v$(date +%Y%m%d).zip"
echo "🚀 Приложение: build/macos/Build/Products/Release/photo_app.app"
```

Использование:
```bash
chmod +x build_release.sh
./build_release.sh
```

## 📞 Поддержка

При возникновении проблем:
1. Проверьте логи в терминале
2. Убедитесь, что все процессы остановлены
3. Очистите файлы блокировки
4. Пересоберите приложение

---
**Версия инструкции:** 1.0  
**Дата обновления:** 23.10.2024  
**Автор:** AI Assistant

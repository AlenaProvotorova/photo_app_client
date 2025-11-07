# 🪟 Инструкция по запуску приложения на Windows

## 📋 Требования

### Системные требования:
- **ОС:** Windows 10 (версия 1903 или новее) / Windows 11
- **Архитектура:** 64-bit (x64)
- **RAM:** минимум 4 GB, рекомендуется 8 GB
- **Место на диске:** минимум 2 GB свободного места
- **Графика:** DirectX 11 совместимая

### Необходимое ПО для разработки:
- **Flutter SDK:** версия 3.27.1 или выше
- **Git:** для клонирования репозитория
- **Visual Studio 2022** (или Visual Studio Build Tools) с компонентами:
  - Desktop development with C++
  - Windows 10/11 SDK
- **Java JDK 17** (для некоторых зависимостей)

## 🚀 Быстрый старт

### ⭐ Вариант 1: Portable версия (РЕКОМЕНДУЕТСЯ - обходит антивирусы)

**Это лучший вариант!** Portable версия не требует установки и обходит большинство антивирусов.

1. **Скачайте Portable версию:**
   - Файл: `PhotoApp-Portable-v*.zip` ⭐
   - **НЕ используйте установщик**, если антивирус его блокирует!

2. **Распакуйте архив:**
   - Распакуйте в любую папку (например: `C:\Program Files\PhotoApp\` или `D:\Apps\PhotoApp\`)
   - **Не требует прав администратора!**

3. **Запустите приложение:**
   - Дважды кликните на `photo_app_client.exe`
   - ИЛИ используйте `Запустить.bat` для быстрого запуска

4. **Готово!** Приложение работает без установки.

**Если антивирус все равно блокирует:**
- См. подробную инструкцию в файле `ANTIVIRUS_BYPASS.md`
- Добавьте папку с приложением в исключения антивируса

### Вариант 2: Установщик (может блокироваться антивирусами)

1. **Скачайте установщик:**
   - Файл: `PhotoApp_Setup_*.exe`
   - ⚠️ Может быть заблокирован некоторыми антивирусами

2. **Запустите установщик:**
   - Если антивирус блокирует, используйте Portable версию вместо этого
   - Следуйте инструкциям мастера установки

3. **Запустите приложение:**
   - Из меню Пуск или с рабочего стола

---

## 🔧 Установка и настройка окружения

### Шаг 1: Установка Flutter

1. **Скачайте Flutter SDK:**
   - Перейдите на https://flutter.dev/docs/get-started/install/windows
   - Скачайте последнюю стабильную версию Flutter SDK
   - Распакуйте в `C:\src\flutter` (или другую папку)

2. **Добавьте Flutter в PATH:**
   - Откройте "Параметры системы" → "Дополнительные параметры системы"
   - Нажмите "Переменные среды"
   - В "Системные переменные" найдите `Path`
   - Нажмите "Изменить" → "Создать"
   - Добавьте путь: `C:\src\flutter\bin`
   - Нажмите "ОК" везде

3. **Проверьте установку:**
   ```powershell
   flutter --version
   flutter doctor
   ```

### Шаг 2: Установка Visual Studio

1. **Скачайте Visual Studio 2022 Community** (бесплатная версия):
   - https://visualstudio.microsoft.com/downloads/

2. **При установке выберите:**
   - ✅ Desktop development with C++
   - ✅ Windows 10 SDK (или Windows 11 SDK)
   - ✅ MSVC v143 - VS 2022 C++ x64/x86 build tools

3. **Проверьте установку:**
   ```powershell
   flutter doctor
   ```
   Должно показать: `[✓] Visual Studio - develop for Windows`

### Шаг 3: Установка Java JDK 17

1. **Скачайте Java JDK 17:**
   - https://adoptium.net/ (рекомендуется)
   - Или Oracle JDK: https://www.oracle.com/java/technologies/downloads/#java17

2. **Установите JDK** и добавьте в PATH:
   - `JAVA_HOME` = `C:\Program Files\Java\jdk-17` (или путь к вашей установке)
   - Добавьте `%JAVA_HOME%\bin` в `Path`

3. **Проверьте:**
   ```powershell
   java -version
   ```

### Шаг 4: Включение поддержки Windows в Flutter

```powershell
flutter config --enable-windows-desktop
flutter doctor
```

---

## 📦 Клонирование и настройка проекта

### Шаг 1: Клонирование репозитория

```powershell
# Перейдите в папку для проектов
cd C:\Projects

# Клонируйте репозиторий
git clone <URL_вашего_репозитория>
cd photo_app_client
```

### Шаг 2: Установка зависимостей

```powershell
# Получите зависимости Flutter
flutter pub get

# Проверьте, что все настроено правильно
flutter doctor -v
```

---

## 🏗️ Сборка приложения

### Вариант 1: Автоматическая сборка (рекомендуется)

Используйте готовый скрипт:

```powershell
# Запустите скрипт сборки
.\scripts\build_windows.bat
```

Скрипт автоматически:
- ✅ Обновит зависимости
- ✅ Очистит предыдущие сборки
- ✅ Соберет релизную версию
- ✅ Создаст ZIP архив
- ✅ Создаст установщик (если установлен Inno Setup)

### Вариант 2: Ручная сборка

```powershell
# 1. Обновите зависимости
flutter pub get

# 2. Очистите предыдущие сборки (опционально)
flutter clean
flutter pub get

# 3. Соберите релизную версию
flutter build windows --release

# 4. Проверьте результат
# Приложение будет в: build\windows\x64\runner\Release\
```

### Результат сборки

После успешной сборки вы найдете:
- **Исполняемый файл:** `build\windows\x64\runner\Release\photo_app_client.exe`
- **Все необходимые библиотеки** в той же папке
- **ZIP архив:** `PhotoApp-Windows-v*.zip` (если использовали скрипт)

---

## ▶️ Запуск приложения

### Запуск из командной строки

```powershell
# Перейдите в папку с собранным приложением
cd build\windows\x64\runner\Release

# Запустите приложение
.\photo_app_client.exe
```

### Запуск из проводника

1. Откройте папку: `build\windows\x64\runner\Release`
2. Дважды кликните на `photo_app_client.exe`

### Запуск в режиме разработки (debug)

```powershell
# Запустите приложение в debug режиме
flutter run -d windows

# Или выберите устройство интерактивно
flutter run
```

---

## 📦 Создание установщика (опционально)

### Установка Inno Setup

1. **Скачайте Inno Setup:**
   - https://jrsoftware.org/isdl.php
   - Установите Inno Setup Compiler

2. **Добавьте в PATH** (опционально):
   - `C:\Program Files (x86)\Inno Setup 6`
   - Или используйте полный путь при компиляции

### Создание установщика

```powershell
# Используйте готовый скрипт
.\scripts\create_windows_installer.bat

# Или вручную
iscc setup.iss /O"installer" /F"PhotoApp_Setup_1.0.1"
```

**Результат:** `installer\PhotoApp_Setup_*.exe`

---

## 🐛 Решение проблем

### Проблема: "Flutter не найден"

**Решение:**
```powershell
# Проверьте, что Flutter в PATH
flutter --version

# Если не работает, добавьте вручную:
$env:Path += ";C:\src\flutter\bin"
```

### Проблема: "Visual Studio не найден"

**Решение:**
1. Убедитесь, что установлен компонент "Desktop development with C++"
2. Перезапустите терминал
3. Проверьте: `flutter doctor`

### Проблема: "Java не найден"

**Решение:**
```powershell
# Проверьте установку Java
java -version

# Установите JAVA_HOME:
$env:JAVA_HOME = "C:\Program Files\Java\jdk-17"
```

### Проблема: Ошибки при сборке

**Решение:**
```powershell
# Очистите кэш и пересоберите
flutter clean
flutter pub get
flutter build windows --release --verbose
```

### Проблема: Приложение не запускается

**Проверьте:**
1. Все DLL файлы на месте в папке Release
2. Visual C++ Redistributable установлен
3. Запустите из командной строки для просмотра ошибок

---

## 📝 Полезные команды

```powershell
# Проверка окружения
flutter doctor -v

# Запуск в debug режиме
flutter run -d windows

# Запуск в release режиме (после сборки)
.\build\windows\x64\runner\Release\photo_app_client.exe

# Анализ кода
flutter analyze

# Запуск тестов
flutter test

# Просмотр логов
flutter logs
```

---

## 🔄 Обновление приложения

```powershell
# 1. Получите последние изменения
git pull

# 2. Обновите зависимости
flutter pub get

# 3. Пересоберите
flutter build windows --release

# 4. Или используйте скрипт
.\scripts\build_windows.bat
```

---

## 📚 Дополнительная информация

- **Flutter документация:** https://flutter.dev/docs
- **Windows desktop разработка:** https://flutter.dev/docs/development/platform-integration/desktop
- **Troubleshooting:** https://flutter.dev/docs/get-started/install/windows#troubleshooting

---

## ✅ Чеклист перед сборкой

- [ ] Flutter установлен и в PATH
- [ ] Visual Studio установлен с нужными компонентами
- [ ] Java JDK 17 установлен
- [ ] `flutter doctor` показывает все галочки для Windows
- [ ] Зависимости установлены (`flutter pub get`)
- [ ] Проект клонирован и настроен
- [ ] Готов к сборке! 🚀

---

**Удачи с разработкой!** 🎉


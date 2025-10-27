@echo off
REM Скрипт для создания установщика Windows приложения

echo ========================================
echo  Создание установщика Photo App для Windows
echo ========================================
echo.

REM Проверка наличия Inno Setup
where iscc >nul 2>&1
if %errorlevel% neq 0 (
    echo [ОШИБКА] Inno Setup не найден в PATH
    echo.
    echo Установите Inno Setup Compiler:
    echo 1. Скачайте с https://jrsoftware.org/isdl.php
    echo 2. Установите Inno Setup
    echo 3. Перезапустите консоль
    echo.
    echo ИЛИ добавьте путь вручную в PATH:
    echo set PATH=%%PATH%%;"C:\Program Files (x86)\Inno Setup 6"
    pause
    exit /b 1
)

echo [✓] Inno Setup найден
echo.

REM Проверка наличия собранного приложения
if not exist "build\windows\runner\Release\photo_app_client.exe" (
    echo [ОШИБКА] Собранное приложение не найдено
    echo.
    echo Сначала соберите приложение:
    echo   flutter build windows --release
    echo.
    pause
    exit /b 1
)

echo [✓] Собранное приложение найдено
echo.

REM Получаем версию из pubspec.yaml
for /f "tokens=2" %%i in ('findstr "version:" pubspec.yaml') do set VERSION=%%i
echo [✓] Версия приложения: %VERSION%
echo.

REM Создаем папку для установщика если её нет
if not exist "installer" mkdir installer

REM Компилируем установщик
echo [*] Компилируем установщик...
iscc setup.iss /O"installer" /F"PhotoApp_Setup_%VERSION%"
if %errorlevel% neq 0 (
    echo [✗] Ошибка при компиляции установщика
    pause
    exit /b 1
)

echo.
echo ========================================
echo  Готово!
echo ========================================
echo.
echo Установщик создан: installer\PhotoApp_Setup_%VERSION%.exe
echo Размер: 
dir "installer\PhotoApp_Setup_%VERSION%.exe" | findstr "PhotoApp"

pause


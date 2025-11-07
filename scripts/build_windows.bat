@echo off
REM Скрипт для сборки Windows приложения
echo 🚀 Начинаем сборку Windows приложения...

REM Проверяем, что мы в правильной директории
if not exist "pubspec.yaml" (
    echo ❌ Ошибка: Запустите скрипт из корневой директории проекта
    exit /b 1
)

REM Получаем версию из pubspec.yaml
for /f "tokens=2" %%i in ('findstr "version:" pubspec.yaml') do set VERSION=%%i
echo 📦 Версия приложения: %VERSION%

REM Обновляем зависимости
echo 📥 Обновляем зависимости...
flutter pub get

REM Очищаем предыдущие сборки
echo 🧹 Очищаем предыдущие сборки...
flutter clean
flutter pub get

REM Собираем релизную версию
echo 🔨 Собираем релизную версию для Windows...
flutter build windows --release

REM Проверяем успешность сборки
if %errorlevel% equ 0 (
    echo ✅ Сборка Windows успешно завершена!
    
    REM Создаем Portable версию (рекомендуется - обходит антивирусы)
    echo 📦 Создаем Portable дистрибутив (обходит антивирусы)...
    powershell -ExecutionPolicy Bypass -File "scripts\create_portable_package.ps1" -Version "%VERSION%"
    
    if %errorlevel% equ 0 (
        echo ✅ Portable дистрибутив создан: PhotoApp-Portable-v%VERSION%.zip
        echo 📁 Размер файла: 
        dir "PhotoApp-Portable-v%VERSION%.zip" | findstr "PhotoApp"
        echo.
        echo ⭐ Рекомендуется использовать Portable версию - она обходит большинство антивирусов!
    ) else (
        echo ⚠️  Ошибка при создании Portable версии, создаем обычный ZIP...
        powershell -Command "$files = Get-ChildItem -Path 'build\windows\x64\runner\Release' -Recurse -File; if ($files.Count -gt 0) { Compress-Archive -LiteralPath $files.FullName -DestinationPath 'PhotoApp-Windows-%VERSION%.zip' -Force; Write-Host 'Package created successfully' } else { Write-Error 'No files found' }"
        if %errorlevel% equ 0 (
            echo ✅ ZIP дистрибутив создан: PhotoApp-Windows-%VERSION%.zip
        ) else (
            echo ❌ Ошибка при создании ZIP архива
            exit /b 1
        )
    )
    
    REM Проверяем наличие Inno Setup
    where iscc >nul 2>&1
    if %errorlevel% equ 0 (
        echo.
        echo 📦 Создаем установщик...
        call scripts\create_windows_installer.bat
    ) else (
        echo.
        echo ℹ️  Inno Setup не найден. Для создания установщика установите Inno Setup Compiler
        echo    Скачать: https://jrsoftware.org/isdl.php
    )
) else (
    echo ❌ Ошибка при сборке Windows приложения
    exit /b 1
)

echo 🎉 Готово! Windows приложение готово к распространению
pause

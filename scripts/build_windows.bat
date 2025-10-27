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
    
    REM Создаем ZIP архив
    echo 📦 Создаем ZIP дистрибутив...
    powershell -Command "$files = Get-ChildItem -Path 'build\windows\runner\Release' -Recurse -File; if ($files.Count -gt 0) { Compress-Archive -LiteralPath $files.FullName -DestinationPath 'PhotoApp-Windows-%VERSION%.zip' -Force; Write-Host 'Package created successfully' } else { Write-Error 'No files found' }"
    
    if %errorlevel% equ 0 (
        echo ✅ ZIP дистрибутив создан: PhotoApp-Windows-%VERSION%.zip
        echo 📁 Размер файла: 
        dir "PhotoApp-Windows-%VERSION%.zip" | findstr "PhotoApp"
    ) else (
        echo ❌ Ошибка при создании ZIP архива
        exit /b 1
    )
) else (
    echo ❌ Ошибка при сборке Windows приложения
    exit /b 1
)

echo 🎉 Готово! Windows приложение готово к распространению
pause

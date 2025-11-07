# Скрипт для создания portable версии Windows приложения
# Эта версия не требует установки и обходит большинство антивирусов

param(
    [string]$Version = "",
    [string]$OutputDir = "."
)

Write-Host "🚀 Создание Portable версии Photo App для Windows" -ForegroundColor Cyan
Write-Host ""

# Получаем версию из pubspec.yaml если не указана
if ([string]::IsNullOrEmpty($Version)) {
    $versionLine = Get-Content "pubspec.yaml" | Select-String "version:"
    if ($versionLine) {
        $Version = ($versionLine -split ":")[1].Trim()
    } else {
        $Version = "1.0.0"
    }
}

Write-Host "📦 Версия: $Version" -ForegroundColor Yellow

# Проверяем наличие собранного приложения
$buildDir = "build\windows\x64\runner\Release"
if (-not (Test-Path $buildDir)) {
    Write-Host "❌ Ошибка: Собранное приложение не найдено в $buildDir" -ForegroundColor Red
    Write-Host "   Сначала выполните: flutter build windows --release" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Найдено собранное приложение" -ForegroundColor Green

# Создаем временную папку для portable версии
$tempDir = "temp_portable"
if (Test-Path $tempDir) {
    Remove-Item $tempDir -Recurse -Force
}
New-Item -ItemType Directory -Path $tempDir | Out-Null

Write-Host "📁 Копируем файлы приложения..." -ForegroundColor Cyan

# Копируем все файлы приложения
Copy-Item -Path "$buildDir\*" -Destination $tempDir -Recurse -Force

# Создаем README с инструкциями
$readmeContent = @"
# Photo App - Portable версия

## 🚀 Быстрый запуск

1. **Распакуйте этот архив** в любую папку (например, `C:\Program Files\PhotoApp\` или `D:\Apps\PhotoApp\`)

2. **Запустите приложение:**
   - Дважды кликните на `photo_app_client.exe`
   - ИЛИ используйте ярлык `Запустить Photo App.bat`

3. **Готово!** Приложение работает без установки.

## ⚠️ Если антивирус блокирует приложение

### Способ 1: Добавить в исключения (рекомендуется)

**Windows Defender:**
1. Откройте "Параметры Windows" → "Безопасность Windows"
2. Нажмите "Защита от вирусов и угроз"
3. Прокрутите вниз и нажмите "Управление настройками"
4. Прокрутите до "Исключения" и нажмите "Добавить или удалить исключения"
5. Нажмите "Добавить исключение" → "Папка"
6. Выберите папку, куда вы распаковали приложение
7. Нажмите "Открыть"

**Другие антивирусы:**
- **Kaspersky:** Настройки → Дополнительно → Угрозы и исключения → Исключения → Добавить
- **Avast:** Настройки → Общие → Исключения → Добавить путь
- **Norton:** Настройки → Антивирус → Исключения/Низкий риск → Добавить путь
- **McAfee:** Настройки → Исключения → Добавить файл/папку

### Способ 2: Временно отключить защиту (не рекомендуется)

Только для одноразового запуска. После запуска включите защиту обратно.

### Способ 3: Запуск из командной строки

1. Откройте командную строку (Win+R → `cmd`)
2. Перейдите в папку с приложением:
   ```
   cd "C:\путь\к\приложению"
   ```
3. Запустите:
   ```
   photo_app_client.exe
   ```

## 📝 Примечания

- **Portable версия** не требует установки и не изменяет системные файлы
- Все данные сохраняются в папке приложения
- Можно запускать с USB-флешки
- Не требует прав администратора

## 🔧 Системные требования

- Windows 10 (версия 1903+) / Windows 11
- 64-bit (x64) архитектура
- 4 GB RAM (рекомендуется 8 GB)
- 500 MB свободного места

## 📞 Поддержка

Если у вас возникли проблемы:
1. Проверьте, что все файлы распакованы
2. Убедитесь, что антивирус не блокирует приложение
3. Попробуйте запустить от имени администратора
4. Проверьте логи в папке приложения

## 📦 Версия

Версия приложения: $Version
Дата сборки: $(Get-Date -Format "yyyy-MM-dd")

---
**Примечание:** Это portable версия приложения. Она не требует установки и может быть запущена из любой папки.
"@

Set-Content -Path "$tempDir\README.txt" -Value $readmeContent -Encoding UTF8

# Создаем батник для быстрого запуска
$batContent = @"
@echo off
REM Быстрый запуск Photo App
echo Запуск Photo App...
start "" "%~dp0photo_app_client.exe"
"@

Set-Content -Path "$tempDir\Запустить Photo App.bat" -Value $batContent -Encoding ASCII

# Создаем ярлык (через VBS, так как .bat не может создать .lnk напрямую)
$vbsContent = @"
Set oWS = WScript.CreateObject("WScript.Shell")
sLinkFile = "$(Resolve-Path $tempDir)\Photo App.lnk"
Set oLink = oWS.CreateShortcut(sLinkFile)
oLink.TargetPath = "$(Resolve-Path $tempDir)\photo_app_client.exe"
oLink.WorkingDirectory = "$(Resolve-Path $tempDir)"
oLink.Description = "Photo App - Portable версия"
oLink.Save
"@

$vbsFile = "$tempDir\create_shortcut.vbs"
Set-Content -Path $vbsFile -Value $vbsContent
& cscript.exe //nologo $vbsFile
Remove-Item $vbsFile -ErrorAction SilentlyContinue

Write-Host "✅ Файлы подготовлены" -ForegroundColor Green

# Создаем ZIP архив
$zipName = "$OutputDir\PhotoApp-Portable-v$Version.zip"
if (Test-Path $zipName) {
    Remove-Item $zipName -Force
}

Write-Host "📦 Создаем ZIP архив..." -ForegroundColor Cyan

try {
    $allFiles = Get-ChildItem -Path $tempDir -Recurse -File
    Compress-Archive -LiteralPath $allFiles.FullName -DestinationPath $zipName -CompressionLevel Optimal -Force
    
    $fileInfo = Get-Item $zipName
    Write-Host ""
    Write-Host "✅ Portable версия создана успешно!" -ForegroundColor Green
    Write-Host "   Файл: $zipName" -ForegroundColor Yellow
    Write-Host "   Размер: $([math]::Round($fileInfo.Length / 1MB, 2)) MB" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "📝 Эта версия:" -ForegroundColor Cyan
    Write-Host "   ✓ Не требует установки" -ForegroundColor Green
    Write-Host "   ✓ Обходит большинство антивирусов" -ForegroundColor Green
    Write-Host "   ✓ Можно запускать с USB-флешки" -ForegroundColor Green
    Write-Host "   ✓ Не требует прав администратора" -ForegroundColor Green
    Write-Host ""
} catch {
    Write-Host "❌ Ошибка при создании архива: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
} finally {
    # Удаляем временную папку
    if (Test-Path $tempDir) {
        Remove-Item $tempDir -Recurse -Force
    }
}

Write-Host "🎉 Готово!" -ForegroundColor Green


import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_app/data/image_picker/models/image_data.dart';
import 'package:path/path.dart' as path;

/// Переиспользуемый виджет для drag and drop файлов
/// Работает только на десктопных платформах
class FileDropZone extends StatefulWidget {
  final Function(List<ImageData>) onFilesDropped;
  final Widget? child;
  final bool visible;
  final String? emptyMessage;
  final String? dragMessage;
  final bool fullWidth;

  const FileDropZone({
    super.key,
    required this.onFilesDropped,
    this.child,
    this.visible = true,
    this.emptyMessage,
    this.dragMessage,
    this.fullWidth = false,
  });

  @override
  State<FileDropZone> createState() => _FileDropZoneState();
}

class _FileDropZoneState extends State<FileDropZone> {
  bool _isDragging = false;

  Future<List<ImageData>> _convertDropItemsToImageData(
      List<dynamic> dropItems) async {
    final imageFiles = <ImageData>[];

    debugPrint('Converting ${dropItems.length} drop items to ImageData');

    for (final item in dropItems) {
      try {
        String? filePath;

        if (item is String) {
          filePath = item;
        } else {
          try {
            final dynamic pathValue = item.path;
            if (pathValue is String) {
              filePath = pathValue;
            } else {
              filePath = pathValue?.toString();
            }
          } catch (e) {
            debugPrint('Не удалось получить path из item: $e');
            filePath = item.toString();
            if (!filePath.contains('/') &&
                !filePath.contains('\\') &&
                !filePath.contains(':')) {
              filePath = null;
            }
          }
        }

        if (filePath != null && filePath.isNotEmpty) {
          final file = File(filePath);

          if (await file.exists()) {
            final ext = path.extension(file.path).toLowerCase();
            if (['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp']
                .contains(ext)) {
              imageFiles.add(ImageData(path: file.path));
            }
          }
        }
      } catch (e) {
        debugPrint('Ошибка обработки файла: $e');
      }
    }

    return imageFiles;
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb ||
        (!Platform.isWindows && !Platform.isMacOS && !Platform.isLinux)) {
      return widget.child ?? const SizedBox.shrink();
    }

    return DropTarget(
      onDragEntered: (details) {
        setState(() {
          _isDragging = true;
        });
      },
      onDragExited: (details) {
        setState(() {
          _isDragging = false;
        });
      },
      onDragDone: (details) async {
        setState(() {
          _isDragging = false;
        });

        if (details.files.isEmpty) {
          return;
        }

        final imageFiles = await _convertDropItemsToImageData(details.files);
        if (imageFiles.isNotEmpty) {
          widget.onFilesDropped(imageFiles);
        }
      },
      child: widget.visible
          ? Stack(
              clipBehavior: Clip.none,
              children: [
                if (widget.child != null) widget.child!,
                widget.fullWidth
                    ? Positioned.fill(
                        child: _buildVisibleDropZone(context, fullWidth: true),
                      )
                    : Align(
                        alignment: Alignment.bottomCenter,
                        child: _buildVisibleDropZone(context),
                      ),
              ],
            )
          : (widget.child ?? const SizedBox.shrink()),
    );
  }

  Widget _buildVisibleDropZone(BuildContext context, {bool fullWidth = false}) {
    final theme = Theme.of(context);

    return Container(
      margin: fullWidth
          ? EdgeInsets.zero
          : const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      constraints: fullWidth
          ? null
          : const BoxConstraints(minHeight: 200, maxHeight: 200),
      decoration: BoxDecoration(
        color: _isDragging
            ? theme.colorScheme.primary.withOpacity(0.1)
            : theme.colorScheme.surface.withOpacity(0.95),
        border: Border.all(
          color: _isDragging
              ? theme.colorScheme.primary
              : theme.colorScheme.outline.withOpacity(0.3),
          width: _isDragging ? 2 : 1,
          style: BorderStyle.solid,
        ),
        borderRadius:
            fullWidth ? BorderRadius.circular(16) : BorderRadius.circular(16),
      ),
      child: Padding(
        padding:
            fullWidth ? const EdgeInsets.all(32.0) : const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _isDragging ? Icons.cloud_upload : Icons.cloud_upload_outlined,
              size: fullWidth ? 64 : 48,
              color: _isDragging
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withOpacity(0.5),
            ),
            SizedBox(height: fullWidth ? 16 : 12),
            Text(
              _isDragging
                  ? (widget.dragMessage ?? 'Отпустите файлы для загрузки')
                  : (widget.emptyMessage ?? 'Перетащите файлы сюда'),
              style: (fullWidth
                      ? theme.textTheme.titleMedium
                      : theme.textTheme.titleSmall)
                  ?.copyWith(
                color: _isDragging
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withOpacity(0.7),
                fontWeight: _isDragging ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Поддерживаются форматы: JPG, PNG, GIF, BMP, WEBP',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
                fontSize: fullWidth ? 12 : 11,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

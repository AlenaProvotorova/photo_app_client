import 'package:flutter/material.dart';

class DateSelector extends StatefulWidget {
  final DateTime? initialDate;
  final Function(DateTime?) onDateChanged;
  final Function(DateTime?) onApply;

  const DateSelector({
    super.key,
    required this.initialDate,
    required this.onDateChanged,
    required this.onApply,
  });

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  DateTime? _selectedDate;
  bool _hasChanged = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  @override
  void didUpdateWidget(DateSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialDate != oldWidget.initialDate) {
      _selectedDate = widget.initialDate;
      _hasChanged = false;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    try {
      final DateTime now = DateTime.now();

      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate ?? now,
        firstDate: DateTime(now.year - 1),
        lastDate: DateTime(2030),
        locale: const Locale('ru', 'RU'),
        builder: (context, child) {
          final theme = Theme.of(context);
          return Theme(
            data: theme.copyWith(
              colorScheme: ColorScheme.light(
                primary: theme.colorScheme.primary,
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black,
                secondary: theme.colorScheme.primary,
                onSecondary: Colors.white,
              ),
              textTheme: const TextTheme(
                bodyLarge: TextStyle(color: Colors.black),
                bodyMedium: TextStyle(color: Colors.black),
                bodySmall: TextStyle(color: Colors.black),
                titleLarge: TextStyle(color: Colors.black),
                titleMedium: TextStyle(color: Colors.black),
                titleSmall: TextStyle(color: Colors.black),
                labelLarge: TextStyle(color: Colors.black),
                labelMedium: TextStyle(color: Colors.black),
                labelSmall: TextStyle(color: Colors.black),
              ),
            ),
            child: child!,
          );
        },
      );

      if (picked != null && picked != _selectedDate) {
        setState(() {
          _selectedDate = picked;
          _hasChanged = true;
        });
        widget.onDateChanged(_selectedDate);
      }
    } catch (e) {
      print('Error selecting date: $e');
      // Можно показать snackbar с ошибкой
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка при выборе даты: $e')),
        );
      }
    }
  }

  void _applyDate() {
    if (_hasChanged && _selectedDate != null) {
      widget.onApply(_selectedDate);
      setState(() {
        _hasChanged = false;
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Не выбрано';
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Установите дату, до которой возможен выбор фотографий клиентами',
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            SizedBox(
              width: 200,
              child: GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  height: 48,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.dividerColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _formatDate(_selectedDate),
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: _hasChanged ? _applyDate : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _hasChanged ? theme.colorScheme.primary : Colors.grey,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Применить'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

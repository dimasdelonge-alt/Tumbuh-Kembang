import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum AppDatePickerStep { year, month, day }

/// Menampilkan Dialog DatePicker custom dengan alur:
/// Pilih Tahun -> Pilih Bulan (Grid 3x4) -> Pilih Tanggal (Grid Kalender).
Future<DateTime?> showAppDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
  DatePickerMode initialDatePickerMode = DatePickerMode.year,
}) async {
  return showDialog<DateTime>(
    context: context,
    builder: (ctx) => AppDatePickerDialog(
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      initialStep: initialDatePickerMode == DatePickerMode.year
          ? AppDatePickerStep.year
          : AppDatePickerStep.day,
    ),
  );
}

class AppDatePickerDialog extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final AppDatePickerStep initialStep;

  const AppDatePickerDialog({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    this.initialStep = AppDatePickerStep.year,
  });

  @override
  State<AppDatePickerDialog> createState() => _AppDatePickerDialogState();
}

class _AppDatePickerDialogState extends State<AppDatePickerDialog> {
  late int _selectedYear;
  late int _selectedMonth;
  late int _selectedDay;
  late AppDatePickerStep _currentStep;
  bool _isTextInputMode = false;
  final TextEditingController _textController = TextEditingController();
  String? _textError;

  static const List<String> _monthNames = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  @override
  void initState() {
    super.initState();
    // Clamp initialDate agar berada di antara firstDate dan lastDate
    var clamped = widget.initialDate;
    if (clamped.isBefore(widget.firstDate)) clamped = widget.firstDate;
    if (clamped.isAfter(widget.lastDate)) clamped = widget.lastDate;

    _selectedYear = clamped.year;
    _selectedMonth = clamped.month;
    _selectedDay = clamped.day;
    _currentStep = widget.initialStep;
    _textController.text =
        '${_selectedDay.toString().padLeft(2, '0')}/${_selectedMonth.toString().padLeft(2, '0')}/$_selectedYear';
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  DateTime get _currentSelectedDate {
    final maxDaysInMonth = DateUtils.getDaysInMonth(_selectedYear, _selectedMonth);
    final day = _selectedDay > maxDaysInMonth ? maxDaysInMonth : _selectedDay;
    var d = DateTime(_selectedYear, _selectedMonth, day);
    if (d.isBefore(widget.firstDate)) d = widget.firstDate;
    if (d.isAfter(widget.lastDate)) d = widget.lastDate;
    return d;
  }

  void _onYearSelected(int year) {
    setState(() {
      _selectedYear = year;
      // Clamp day jika tanggal > max hari di bulan baru
      final maxDays = DateUtils.getDaysInMonth(_selectedYear, _selectedMonth);
      if (_selectedDay > maxDays) _selectedDay = maxDays;
      // Otomatis lanjut ke Pilih Bulan
      _currentStep = AppDatePickerStep.month;
    });
  }

  void _onMonthSelected(int month) {
    setState(() {
      _selectedMonth = month;
      final maxDays = DateUtils.getDaysInMonth(_selectedYear, _selectedMonth);
      if (_selectedDay > maxDays) _selectedDay = maxDays;
      // Otomatis lanjut ke Pilih Tanggal
      _currentStep = AppDatePickerStep.day;
    });
  }

  void _onDaySelected(int day) {
    setState(() {
      _selectedDay = day;
    });
  }

  void _submit() {
    if (_isTextInputMode) {
      final text = _textController.text.trim();
      final parts = text.split('/');
      if (parts.length != 3) {
        setState(() => _textError = 'Format harus dd/mm/yyyy (misal: 15/08/2021)');
        return;
      }
      final d = int.tryParse(parts[0]);
      final m = int.tryParse(parts[1]);
      final y = int.tryParse(parts[2]);
      if (d == null || m == null || y == null || m < 1 || m > 12 || d < 1) {
        setState(() => _textError = 'Tanggal tidak valid');
        return;
      }
      final maxDays = DateUtils.getDaysInMonth(y, m);
      if (d > maxDays) {
        setState(() => _textError = 'Bulan ini hanya sampai tanggal $maxDays');
        return;
      }
      final date = DateTime(y, m, d);
      if (date.isBefore(widget.firstDate) || date.isAfter(widget.lastDate)) {
        setState(() => _textError = 'Tanggal di luar rentang yang diizinkan');
        return;
      }
      Navigator.of(context).pop(date);
    } else {
      Navigator.of(context).pop(_currentSelectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final formattedHeader = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(_currentSelectedDate);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380, maxHeight: 560),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header Bar
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              color: colorScheme.primary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _isTextInputMode ? 'Ketik Tanggal' : 'Pilih Tanggal',
                        style: TextStyle(
                          color: colorScheme.onPrimary.withValues(alpha: 0.8),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _isTextInputMode ? Icons.calendar_month : Icons.edit_calendar,
                          color: colorScheme.onPrimary,
                          size: 20,
                        ),
                        tooltip: _isTextInputMode ? 'Mode Kalender' : 'Mode Ketik Manual',
                        onPressed: () {
                          setState(() {
                            _isTextInputMode = !_isTextInputMode;
                            _textError = null;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    formattedHeader,
                    style: TextStyle(
                      color: colorScheme.onPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (!_isTextInputMode) ...[
                    const SizedBox(height: 12),
                    // Navigation Chips Header: [Tahun] [Bulan] [Tanggal]
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _headerChip(
                            label: 'Tahun $_selectedYear',
                            isActive: _currentStep == AppDatePickerStep.year,
                            onTap: () => setState(() => _currentStep = AppDatePickerStep.year),
                          ),
                          const SizedBox(width: 6),
                          _headerChip(
                            label: _monthNames[_selectedMonth - 1],
                            isActive: _currentStep == AppDatePickerStep.month,
                            onTap: () => setState(() => _currentStep = AppDatePickerStep.month),
                          ),
                          const SizedBox(width: 6),
                          _headerChip(
                            label: 'Tgl $_selectedDay',
                            isActive: _currentStep == AppDatePickerStep.day,
                            onTap: () => setState(() => _currentStep = AppDatePickerStep.day),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Body Area
            Expanded(
              child: _isTextInputMode
                  ? _buildTextInputView(colorScheme)
                  : AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: _buildStepView(colorScheme),
                    ),
            ),

            // Footer Buttons
            Divider(height: 1, color: theme.dividerColor),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (!_isTextInputMode && DateTime.now().isAfter(widget.firstDate) && DateTime.now().isBefore(widget.lastDate)) ...[
                      TextButton.icon(
                        icon: const Icon(Icons.today, size: 16),
                        label: const Text('Hari Ini'),
                        onPressed: () {
                          final now = DateTime.now();
                          setState(() {
                            _selectedYear = now.year;
                            _selectedMonth = now.month;
                            _selectedDay = now.day;
                            _currentStep = AppDatePickerStep.day;
                          });
                        },
                      ),
                      const SizedBox(width: 12),
                    ],
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Batal'),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: _submit,
                      child: const Text('Pilih'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerChip({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isActive
              ? Colors.white
              : Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildStepView(ColorScheme colorScheme) {
    switch (_currentStep) {
      case AppDatePickerStep.year:
        return _buildYearGrid(colorScheme);
      case AppDatePickerStep.month:
        return _buildMonthGrid(colorScheme);
      case AppDatePickerStep.day:
        return _buildDayGrid(colorScheme);
    }
  }

  /// Grid Pemilihan Tahun (Termasuk tahun sekarang turun sampai firstDate)
  Widget _buildYearGrid(ColorScheme colorScheme) {
    final startYear = widget.lastDate.year;
    final endYear = widget.firstDate.year;
    final years = List.generate(startYear - endYear + 1, (index) => startYear - index);

    return Column(
      key: const ValueKey('year_step'),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          child: Row(
            children: [
              Icon(Icons.calendar_today, size: 16, color: colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Langkah 1 dari 3: Pilih Tahun Lahir / Periksa',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2.2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: years.length,
            itemBuilder: (context, index) {
              final year = years[index];
              final isSelected = year == _selectedYear;
              final isCurrent = year == DateTime.now().year;

              return InkWell(
                onTap: () => _onYearSelected(year),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colorScheme.primary
                        : (isCurrent
                            ? colorScheme.primaryContainer
                            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)),
                    borderRadius: BorderRadius.circular(10),
                    border: isSelected
                        ? null
                        : Border.all(
                            color: isCurrent
                                ? colorScheme.primary
                                : colorScheme.outline.withValues(alpha: 0.2),
                          ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    year.toString(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected || isCurrent ? FontWeight.bold : FontWeight.normal,
                      color: isSelected
                          ? colorScheme.onPrimary
                          : (isCurrent ? colorScheme.onPrimaryContainer : colorScheme.onSurface),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Grid Pemilihan Bulan (12 Bulan 3x4 Grid)
  Widget _buildMonthGrid(ColorScheme colorScheme) {
    return Column(
      key: const ValueKey('month_step'),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          child: Row(
            children: [
              Icon(Icons.date_range, size: 16, color: colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Langkah 2 dari 3: Pilih Bulan ($_selectedYear)',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.8,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: 12,
            itemBuilder: (context, index) {
              final month = index + 1;
              final isSelected = month == _selectedMonth;

              // Check isDisabled jika di luar rentang firstDate/lastDate
              final firstMonthInYear = widget.firstDate.year == _selectedYear ? widget.firstDate.month : 1;
              final lastMonthInYear = widget.lastDate.year == _selectedYear ? widget.lastDate.month : 12;
              final isDisabled = month < firstMonthInYear || month > lastMonthInYear;

              return InkWell(
                onTap: isDisabled ? null : () => _onMonthSelected(month),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colorScheme.primary
                        : (isDisabled
                            ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.1)
                            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _monthNames[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected
                          ? colorScheme.onPrimary
                          : (isDisabled
                              ? colorScheme.onSurface.withValues(alpha: 0.3)
                              : colorScheme.onSurface),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Grid Pemilihan Tanggal (Kalender Hari)
  Widget _buildDayGrid(ColorScheme colorScheme) {
    final daysInMonth = DateUtils.getDaysInMonth(_selectedYear, _selectedMonth);
    final firstDayOfMonth = DateTime(_selectedYear, _selectedMonth, 1);
    // 1 = Senin, 7 = Minggu
    final leadingEmptyDays = firstDayOfMonth.weekday - 1;

    const dayHeaders = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

    return Column(
      key: const ValueKey('day_step'),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          child: Row(
            children: [
              Icon(Icons.calendar_month, size: 16, color: colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Langkah 3 dari 3: Pilih Tanggal (${_monthNames[_selectedMonth - 1]} $_selectedYear)',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        // Header Hari (Sen - Min)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: dayHeaders
                .map(
                  (h) => SizedBox(
                    width: 32,
                    child: Text(
                      h,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: h == 'Min' ? Colors.red.shade700 : colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.0,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: leadingEmptyDays + daysInMonth,
            itemBuilder: (context, index) {
              if (index < leadingEmptyDays) {
                return const SizedBox();
              }
              final day = index - leadingEmptyDays + 1;
              final date = DateTime(_selectedYear, _selectedMonth, day);
              final isSelected = day == _selectedDay;
              final isToday = date.year == DateTime.now().year &&
                  date.month == DateTime.now().month &&
                  date.day == DateTime.now().day;
              final isDisabled = date.isBefore(widget.firstDate) || date.isAfter(widget.lastDate);

              return InkWell(
                onTap: isDisabled ? null : () => _onDaySelected(day),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colorScheme.primary
                        : (isToday ? colorScheme.primaryContainer : null),
                    shape: BoxShape.circle,
                    border: isToday && !isSelected
                        ? Border.all(color: colorScheme.primary, width: 1.5)
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    day.toString(),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.normal,
                      color: isSelected
                          ? colorScheme.onPrimary
                          : (isDisabled
                              ? colorScheme.onSurface.withValues(alpha: 0.3)
                              : (isToday
                                  ? colorScheme.onPrimaryContainer
                                  : colorScheme.onSurface)),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Mode Ketik Teks Manual
  Widget _buildTextInputView(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ketik tanggal secara manual (Format: Tgl/Bln/Thn)',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _textController,
            keyboardType: TextInputType.datetime,
            decoration: InputDecoration(
              hintText: '15/08/2021',
              prefixIcon: const Icon(Icons.edit_calendar),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              errorText: _textError,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Contoh: 15/08/2021 untuk 15 Agustus 2021.',
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DatePickerDialog extends StatefulWidget {
  final DateTime? initialDate;
  final Function(DateTime) onDateSelected;

  const DatePickerDialog({
    super.key,
    this.initialDate,
    required this.onDateSelected,
  });

  @override
  State<DatePickerDialog> createState() => _DatePickerDialogState();
}

class _DatePickerDialogState extends State<DatePickerDialog> {
  late DateTime currentMonth;
  DateTime? selectedDate;
  final DateTime today = DateTime.now(); // Store DateTime.now() once

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate ?? today;
    currentMonth = DateTime(selectedDate!.year, selectedDate!.month);
  }

  void _previousMonth() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month + 1);
    });
  }

  void _onDateTap(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  void _onConfirm() {
    if (selectedDate != null) {
      widget.onDateSelected(selectedDate!);
      Navigator.of(context).pop();
    }
  }

  void _onCancel() {
    Navigator.of(context).pop();
  }

  List<DateTime> _getDaysInMonth() {
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final lastDayOfMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0);

    List<DateTime> days = [];

    // Add empty days for alignment (Monday is 1, Sunday is 7)
    // Adjust to start from Sunday (1) for display (Flutter's weekday starts with Monday=1, Sunday=7)
    final int firstWeekdayAdjusted = (firstDayOfMonth.weekday == 7) ? 0 : firstDayOfMonth.weekday; // Make Sunday 0
    for (int i = 0; i < firstWeekdayAdjusted; i++) {
      days.add(DateTime(0)); // Placeholder
    }

    // Add actual days
    for (int i = 1; i <= lastDayOfMonth.day; i++) {
      days.add(DateTime(currentMonth.year, currentMonth.month, i));
    }

    return days;
  }

  bool _isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF1A2332),
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Row(
                children: [
                  // Close button
                  GestureDetector(
                    onTap: _onCancel,
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Title
                  Text(
                    '날짜 선택',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(width: 40.w), // Balance for close button
                ],
              ),
            ),

            // Month selector
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: const Color(0xFF0F1419),
                border: Border(
                  top: BorderSide(color: const Color(0xFF2D3748), width: 1.h),
                  bottom: BorderSide(color: const Color(0xFF2D3748), width: 1.h),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Previous month button
                  GestureDetector(
                    onTap: _previousMonth,
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      child: Icon(
                        Icons.chevron_left,
                        color: Colors.white,
                        size: 28.sp,
                      ),
                    ),
                  ),
                  // Current month and year
                  Text(
                    '${currentMonth.year}년 ${currentMonth.month}월',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Next month button - disabled if currentMonth is today's month or after
                  GestureDetector(
                    onTap: currentMonth.isBefore(DateTime(today.year, today.month)) ? _nextMonth : null,
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      child: Icon(
                        Icons.chevron_right,
                        color: currentMonth.isBefore(DateTime(today.year, today.month)) ? Colors.white : Colors.white.withOpacity(0.3),
                        size: 28.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Calendar
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                children: [
                  // Weekday labels
                  _buildWeekdayLabels(),
                  SizedBox(height: 12.h),
                  // Calendar grid
                  _buildCalendarGrid(),
                ],
              ),
            ),

            // Action buttons
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
              child: Row(
                children: [
                  // Cancel button
                  Expanded(
                    child: GestureDetector(
                      onTap: _onCancel,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2D3748),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '취소',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // Confirm button
                  Expanded(
                    child: GestureDetector(
                      onTap: _onConfirm,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '확인',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekdayLabels() {
    const weekdays = ['일', '월', '화', '수', '목', '금', '토'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekdays.map((day) {
        return SizedBox(
          width: 12.w,
          child: Center(
            child: Text(
              day,
              style: TextStyle(
                color: const Color(0xFF6B7280),
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendarGrid() {
    final days = _getDaysInMonth();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8.h,
        crossAxisSpacing: 8.w,
        childAspectRatio: 1.0,
      ),
      itemCount: days.length,
      itemBuilder: (context, index) {
        final date = days[index];

        // Empty cell (placeholder dates)
        if (date.year == 0) {
          return const SizedBox.shrink();
        }

        final isSelected = _isSameDay(date, selectedDate);
        final isToday = _isSameDay(date, today);

        // Determine if the date is selectable (today or in the past)
        final bool isSelectable = !date.isAfter(today);

        return GestureDetector(
          onTap: isSelectable ? () => _onDateTap(date) : null,
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF3B82F6)
                  : (isSelectable ? Colors.transparent : Colors.grey.withOpacity(0.1)),
              border: isToday && !isSelected
                  ? Border.all(
                color: const Color(0xFF3B82F6),
                width: 2.w,
              )
                  : (isSelectable ? Border.all( // Apply border only if selectable and not today
                color: const Color(0xFF2D3748),
                width: 1.w,
              ) : null), // No border for unselectable dates
              borderRadius: BorderRadius.circular(12.r),
            ),
            alignment: Alignment.center,
            child: Text(
              '${date.day}',
              style: TextStyle(
                color: isSelectable ? Colors.white : Colors.white.withOpacity(0.3),
                fontSize: 16.sp,
                fontWeight: isSelected || isToday
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ),
        );
      },
    );
  }
}

// Usage example:
void showDatePickerDialog(
    BuildContext context, {
      DateTime? initialDate,
      required Function(DateTime) onDateSelected,
    }) {
  showDialog(
    context: context,
    builder: (context) => DatePickerDialog(
      initialDate: initialDate,
      onDateSelected: onDateSelected,
    ),
  );
}

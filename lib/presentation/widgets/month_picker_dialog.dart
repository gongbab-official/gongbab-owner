import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MonthPickerDialog extends StatefulWidget {
  final DateTime? initialDate;
  final Function(DateTime) onMonthSelected;

  const MonthPickerDialog({
    Key? key,
    this.initialDate,
    required this.onMonthSelected,
  }) : super(key: key);

  @override
  State<MonthPickerDialog> createState() => _MonthPickerDialogState();
}

class _MonthPickerDialogState extends State<MonthPickerDialog> {
  late int currentYear;
  int? selectedMonth;
  final DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    final initial = widget.initialDate ?? _now;
    currentYear = initial.year;
    selectedMonth = initial.month;
  }

  void _previousYear() {
    setState(() {
      currentYear--;
    });
  }

  void _nextYear() {
    setState(() {
      currentYear++;
    });
  }

  void _onMonthTap(int month) {
    setState(() {
      selectedMonth = month;
    });
  }

  void _onConfirm() {
    if (selectedMonth != null) {
      widget.onMonthSelected(DateTime(currentYear, selectedMonth!));
      Navigator.of(context).pop();
    }
  }

  void _onCancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 600.w,
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
                    '월 선택',
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

            // Year selector
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
                  // Previous year button
                  GestureDetector(
                    onTap: _previousYear,
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      child: Icon(
                        Icons.chevron_left,
                        color: Colors.white,
                        size: 28.sp,
                      ),
                    ),
                  ),
                  // Current year
                  Text(
                    '${currentYear}년',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Next year button - disabled if currentYear is _now.year
                  GestureDetector(
                    onTap: currentYear < _now.year ? _nextYear : null,
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      child: Icon(
                        Icons.chevron_right,
                        color: currentYear < _now.year ? Colors.white : Colors.white.withOpacity(0.3),
                        size: 28.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Month grid
            Padding(
              padding: EdgeInsets.all(20.w),
              child: _buildMonthGrid(),
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

  Widget _buildMonthGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
        childAspectRatio: 2.2,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        final month = index + 1;
        final isSelected = selectedMonth == month;
        
        final bool isSelectable = (currentYear < _now.year) ||
                                  (currentYear == _now.year && month <= _now.month);

        return GestureDetector(
          onTap: isSelectable ? () => _onMonthTap(month) : null,
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF3B82F6)
                  : (isSelectable ? Colors.transparent : Colors.grey.withOpacity(0.1)),
              border: (currentYear == _now.year && month == _now.month && !isSelected)
                  ? Border.all(
                color: const Color(0xFF3B82F6),
                width: 2.w,
              )
                  : Border.all(
                color: isSelectable ? const Color(0xFF2D3748) : Colors.transparent, // Border for unselectable
                width: 1.w,
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
            alignment: Alignment.center,
            child: Text(
              '$month월',
              style: TextStyle(
                color: isSelectable ? Colors.white : Colors.white.withOpacity(0.3),
                fontSize: 16.sp,
                fontWeight: isSelected || (currentYear == _now.year && month == _now.month)
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
void showMonthPickerDialog(
    BuildContext context, {
      DateTime? initialDate,
      required Function(DateTime) onMonthSelected,
    }) {
  showDialog(
    context: context,
    builder: (context) => MonthPickerDialog(
      initialDate: initialDate,
      onMonthSelected: onMonthSelected,
    ),
  );
}
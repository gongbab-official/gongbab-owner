import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String? content;
  final String? leftButtonText;
  final VoidCallback? onLeftButtonPressed;
  final String rightButtonText;
  final VoidCallback onRightButtonPressed;

  const CustomAlertDialog({
    super.key,
    required this.title,
    this.content,
    this.leftButtonText,
    this.onLeftButtonPressed,
    required this.rightButtonText,
    required this.onRightButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1a1f2e),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            if (content != null) ...[
              SizedBox(height: 12.h),
              Text(
                content!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ],
            SizedBox(height: 24.h),
            if (leftButtonText != null)
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onLeftButtonPressed?.call();
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFEF4444),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r)),
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                      ),
                      child: Text(leftButtonText!, style: TextStyle(fontSize: 14.sp),),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onRightButtonPressed.call();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3b82f6),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r)),
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                      ),
                      child: Text(rightButtonText, style: TextStyle(fontSize: 14.sp),),
                    ),
                  ),
                ],
              )
            else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onRightButtonPressed.call();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3b82f6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r)),
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                  ),
                  child: Text(rightButtonText, style: TextStyle(fontSize: 14.sp)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:gongbab_owner/domain/entities/meal_log/meal_log.dart';
import 'package:gongbab_owner/presentation/screens/company_meal_detail/company_meal_detail_event.dart';
import 'package:gongbab_owner/presentation/screens/company_meal_detail/company_meal_detail_ui_state.dart';
import 'package:gongbab_owner/presentation/screens/company_meal_detail/company_meal_detail_view_model.dart';

class CompanyMealDetailScreen extends StatefulWidget {
  final int companyId;
  final String companyName;
  final DateTime selectedDate;

  const CompanyMealDetailScreen({
    super.key,
    required this.companyId,
    required this.companyName,
    required this.selectedDate,
  });

  @override
  State<CompanyMealDetailScreen> createState() =>
      _CompanyMealDetailScreenState();
}

class _CompanyMealDetailScreenState extends State<CompanyMealDetailScreen> {
  late CompanyMealDetailViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = GetIt.instance<CompanyMealDetailViewModel>();
    _viewModel.addListener(_onViewModelChange);
    _loadMealLogs();
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChange);
    super.dispose();
  }

  void _onViewModelChange() {
    setState(() {});
  }

  void _loadMealLogs() {
    final formattedDate =
        widget.selectedDate.toIso8601String().split('T').first;
    _viewModel.onEvent(LoadMealLogs(
      companyId: widget.companyId,
      date: formattedDate,
    ));
  }

  Future<void> _onRefresh() async {
    _loadMealLogs();
  }

  String _formatDate(DateTime date) {
    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    final weekday = weekdays[date.weekday - 1];
    return '${date.year}년 ${date.month}월 ${date.day}일 ($weekday)';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1419),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1419),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          widget.companyName,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _buildBody(_viewModel.uiState),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side (e.g., date picker) - can be added later if needed
          SizedBox(width: 24.w), // Placeholder for left icon
          Text(
            _formatDate(widget.selectedDate),
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Right side (e.g., filter or export) - can be added later if needed
          SizedBox(width: 24.w), // Placeholder for right icon
        ],
      ),
    );
  }

  Widget _buildBody(CompanyMealDetailUiState state) {
    if (state is Loading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is Error) {
      return Center(
        child: Text(
          state.message,
          style: const TextStyle(color: Colors.white),
        ),
      );
    } else if (state is Success) {
      return RefreshIndicator(
        onRefresh: _onRefresh,
        color: const Color(0xFF3B82F6),
        backgroundColor: const Color(0xFF1A2332),
        child: Column(
          children: [
            _buildMealLogSummary(state.mealLog),
            Expanded(child: _buildMealLogItems(state.mealLog.items)),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildMealLogSummary(MealLog mealLog) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.restaurant_menu,
                color: const Color(0xFF3B82F6),
                size: 20.sp,
              ),
              SizedBox(width: 4.w),
              Text(
                '식사 내역',
                style: TextStyle(
                  color: const Color(0xFF3B82F6),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            '총 식사 인원: ${mealLog.totalCount}명',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            '조식: ${mealLog.items.where((item) => item.mealType == 'BREAKFAST').length}명, 중식: ${mealLog.items.where((item) => item.mealType == 'LUNCH').length}명, 석식: ${mealLog.items.where((item) => item.mealType == 'DINNER').length}명',
            style: TextStyle(
              color: const Color(0xFF6B7280),
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealLogItems(List<MealLogItem> items) {
    if (items.isEmpty) {
      return const Center(
        child: Text(
          '식사 내역이 없습니다.',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _buildMealLogItemCard(items[index]);
      },
    );
  }

  Widget _buildMealLogItemCard(MealLogItem item) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2332),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFF2D3748),
          width: 1.5.w,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${item.employeeName} (${item.mealLogId})',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            '식사 타입: ${item.mealType}',
            style: TextStyle(
              color: const Color(0xFF9CA3AF),
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            '식사 시간: ${item.time}',
            style: TextStyle(
              color: const Color(0xFF9CA3AF),
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}

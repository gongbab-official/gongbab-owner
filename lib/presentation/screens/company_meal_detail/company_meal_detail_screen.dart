import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

enum MealType { all, breakfast, lunch, dinner }

class CompanyMealDetailScreen extends StatefulWidget {
  final String companyName;
  final DateTime selectedDate;

  const CompanyMealDetailScreen({
    super.key,
    required this.companyName,
    required this.selectedDate,
  });

  @override
  State<CompanyMealDetailScreen> createState() =>
      _CompanyMealDetailScreenState();
}

class _CompanyMealDetailScreenState extends State<CompanyMealDetailScreen> {
  MealType selectedMealType = MealType.all;
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  // Sample data
  final List<EmployeeMealRecord> allRecords = [
    EmployeeMealRecord(
      name: '김철수',
      mealType: MealType.breakfast,
      loggedTime: '07:45:22',
    ),
    EmployeeMealRecord(
      name: '이영희',
      mealType: MealType.lunch,
      loggedTime: '12:15:05',
    ),
    EmployeeMealRecord(
      name: '박지성',
      mealType: MealType.lunch,
      loggedTime: '12:17:48',
    ),
    EmployeeMealRecord(
      name: '강하늘',
      mealType: MealType.dinner,
      loggedTime: '18:30:12',
    ),
    EmployeeMealRecord(
      name: '정우성',
      mealType: MealType.dinner,
      loggedTime: '18:42:55',
    ),
  ];

  int currentPage = 1;
  final int itemsPerPage = 20;

  List<EmployeeMealRecord> get filteredRecords {
    var records = allRecords;

    // Filter by meal type
    if (selectedMealType != MealType.all) {
      records = records
          .where((record) => record.mealType == selectedMealType)
          .toList();
    }

    // Filter by search
    if (searchController.text.isNotEmpty) {
      records = records
          .where((record) => record.name.contains(searchController.text))
          .toList();
    }

    return records;
  }

  List<EmployeeMealRecord> get displayedRecords {
    final totalItems = currentPage * itemsPerPage;
    return filteredRecords.take(totalItems).toList();
  }

  bool get hasMoreRecords {
    return filteredRecords.length > displayedRecords.length;
  }

  int get breakfastCount =>
      allRecords.where((r) => r.mealType == MealType.breakfast).length;

  int get lunchCount =>
      allRecords.where((r) => r.mealType == MealType.lunch).length;

  int get dinnerCount =>
      allRecords.where((r) => r.mealType == MealType.dinner).length;

  @override
  void dispose() {
    searchController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _loadMore() {
    setState(() {
      currentPage++;
    });
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
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Fixed header section (meal summary + tabs + search)
          _buildFixedHeader(),

          // Scrollable employee list
          Expanded(
            child: _buildEmployeeList(),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF0F1419),
      elevation: 0,
      leading: IconButton(
        padding: EdgeInsets.only(left: 16.w),
        onPressed: () => context.pop(),
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
          size: 24.sp,
        ),
      ),
      title: Text(
        '식사 상세 내역',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildFixedHeader() {
    return Container(
      color: const Color(0xFF0F1419),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Selected date
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 16.h),
            child: Text(
              _formatDate(widget.selectedDate),
              style: TextStyle(
                color: const Color(0xFF3B82F6),
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Meal summary cards
          _buildMealSummaryCards(),

          // Meal type tabs
          _buildMealTypeTabs(),

          // Search field
          _buildSearchField(),
        ],
      ),
    );
  }

  Widget _buildMealSummaryCards() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          Expanded(
            child: _buildMealSummaryCard(
              label: '조식',
              count: breakfastCount,
              icon: Icons.wb_sunny_outlined,
              iconColor: const Color(0xFFFF9800),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildMealSummaryCard(
              label: '중식',
              count: lunchCount,
              icon: Icons.wb_sunny,
              iconColor: const Color(0xFFFFC107),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildMealSummaryCard(
              label: '석식',
              count: dinnerCount,
              icon: Icons.nightlight_round,
              iconColor: const Color(0xFF7C3AED),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealSummaryCard({
    required String label,
    required int count,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: const Color(0xFF9CA3AF),
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(width: 2.w),
              Icon(
                icon,
                color: iconColor,
                size: 20.sp,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            count.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealTypeTabs() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
      child: Row(
        children: [
          _buildTabButton('전체', MealType.all),
          SizedBox(width: 8.w),
          _buildTabButton('조식', MealType.breakfast),
          SizedBox(width: 8.w),
          _buildTabButton('중식', MealType.lunch),
          SizedBox(width: 8.w),
          _buildTabButton('석식', MealType.dinner),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, MealType type) {
    final isSelected = selectedMealType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMealType = type;
          currentPage = 1;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3B82F6) : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
          border: isSelected
              ? null
              : Border(
                  bottom: BorderSide(
                    color: const Color(0xFF2D3748),
                    width: 2.h,
                  ),
                ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF9CA3AF),
            fontSize: 14.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
          color: const Color(0xFF1A2332),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: const Color(0xFF2D3748),
            width: 1.5.w,
          ),
        ),
        child: TextField(
          controller: searchController,
          onChanged: (value) {
            setState(() {
              currentPage = 1;
            });
          },
          style: TextStyle(
            color: Colors.white,
            fontSize: 15.sp,
          ),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            hintText: '임직원 이름 검색...',
            hintStyle: TextStyle(
              color: const Color(0xFF6B7280),
              fontSize: 14.sp,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: const Color(0xFF6B7280),
              size: 22.sp,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmployeeList() {
    return ListView.builder(
      controller: scrollController,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemCount: displayedRecords.length + 2, // +2 for header and footer
      itemBuilder: (context, index) {
        // Header
        if (index == 0) {
          return _buildListHeader();
        }

        // Footer (Load more button)
        if (index == displayedRecords.length + 1) {
          if (hasMoreRecords && displayedRecords.length >= itemsPerPage) {
            return _buildLoadMoreButton();
          }
          return SizedBox(height: 20.h);
        }

        // Employee record
        final record = displayedRecords[index - 1];
        return _buildEmployeeRecordCard(record);
      },
    );
  }

  Widget _buildListHeader() {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '식사 인원 내역',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '총 ${filteredRecords.length}건',
            style: TextStyle(
              color: const Color(0xFF3B82F6),
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeRecordCard(EmployeeMealRecord record) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2332),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xFF2D3748),
          width: 1.5.w,
        ),
      ),
      child: Row(
        children: [
          // Meal type icon
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: record.getMealTypeColor().withOpacity(0.15),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              record.getMealTypeIcon(),
              color: record.getMealTypeColor(),
              size: 24.sp,
            ),
          ),
          SizedBox(width: 16.w),

          // Employee info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  record.getMealTypeLabel(),
                  style: TextStyle(
                    color: const Color(0xFF6B7280),
                    fontSize: 13.sp,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),

          // Logged time
          Text(
            record.loggedTime,
            style: TextStyle(
              color: const Color(0xFF9CA3AF),
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadMoreButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: GestureDetector(
        onTap: _loadMore,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          decoration: BoxDecoration(
            color: const Color(0xFF1A2332),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: const Color(0xFF3B82F6),
              width: 2.w,
            ),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.refresh,
                color: const Color(0xFF3B82F6),
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                '상세 내역 더보기 (${displayedRecords.length}/${filteredRecords.length})',
                style: TextStyle(
                  color: const Color(0xFF3B82F6),
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmployeeMealRecord {
  final String name;
  final MealType mealType;
  final String loggedTime;

  EmployeeMealRecord({
    required this.name,
    required this.mealType,
    required this.loggedTime,
  });

  IconData getMealTypeIcon() {
    switch (mealType) {
      case MealType.breakfast:
        return Icons.wb_sunny_outlined;
      case MealType.lunch:
        return Icons.wb_sunny;
      case MealType.dinner:
        return Icons.nightlight_round;
      default:
        return Icons.restaurant;
    }
  }

  Color getMealTypeColor() {
    switch (mealType) {
      case MealType.breakfast:
        return const Color(0xFFFF9800);
      case MealType.lunch:
        return const Color(0xFFFFC107);
      case MealType.dinner:
        return const Color(0xFF7C3AED);
      default:
        return const Color(0xFF3B82F6);
    }
  }

  String getMealTypeLabel() {
    switch (mealType) {
      case MealType.breakfast:
        return '조식';
      case MealType.lunch:
        return '중식';
      case MealType.dinner:
        return '석식';
      default:
        return 'MEAL LOGGED';
    }
  }
}

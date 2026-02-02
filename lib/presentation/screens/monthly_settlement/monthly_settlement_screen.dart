import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/month_picker_dialog.dart';

class MonthlySettlementScreen extends StatefulWidget {
  const MonthlySettlementScreen({super.key});

  @override
  State<MonthlySettlementScreen> createState() =>
      _MonthlySettlementScreenState();
}

class _MonthlySettlementScreenState extends State<MonthlySettlementScreen> {
  DateTime selectedMonth = DateTime.now();

  // Sample data
  final List<CompanySettlement> companies = [
    CompanySettlement(
      name: '(주)미래산업',
      totalMeals: 850,
      unitPrice: 5500,
      totalAmount: 4675000,
    ),
    CompanySettlement(
      name: '(주)에이치앱',
      totalMeals: 1250,
      unitPrice: 5500,
      totalAmount: 6875000,
    ),
    CompanySettlement(
      name: '글로벌로지스',
      totalMeals: 300,
      unitPrice: 6000,
      totalAmount: 1800000,
    ),
  ];

  int get totalMeals =>
      companies.fold(0, (sum, company) => sum + company.totalMeals);

  int get totalAmount =>
      companies.fold(0, (sum, company) => sum + company.totalAmount);

  void _selectMonth() {
    showMonthPickerDialog(
      context,
      initialDate: selectedMonth,
      onMonthSelected: (date) {
        setState(() {
          selectedMonth = date;
        });
      },
    );
  }

  String _formatMonth(DateTime date) {
    const months = [
      '1월',
      '2월',
      '3월',
      '4월',
      '5월',
      '6월',
      '7월',
      '8월',
      '9월',
      '10월',
      '11월',
      '12월',
    ];
    return '${date.year}년 ${months[date.month - 1]} ';
  }

  String _formatCurrency(int amount) {
    return '₩${amount.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]},',
    )}';
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]},',
    );
  }

  void _exportToExcel() {
    // TODO: Implement Excel export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('엑셀 다운로드 기능 구현 예정'),
        backgroundColor: const Color(0xFF3B82F6),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1419),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Month selector
                  _buildMonthSelector(),

                  // Summary card
                  _buildSummaryCard(),

                  // Detailed breakdown header
                  _buildDetailedBreakdownHeader(),

                  // Table
                  _buildSettlementTable(),

                  SizedBox(height: 20.h), // Space for bottom button
                ],
              ),
            ),
          ),

          // Excel export button
          _buildExportButton(),
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
        onPressed: () => Navigator.pop(context),
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
          size: 24.sp,
        ),
      ),
      title: Text(
        '월별 정산',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildMonthSelector() {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SELECT SETTLEMENT MONTH',
            style: TextStyle(
              color: const Color(0xFF6B7280),
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 4.h),
          GestureDetector(
            onTap: _selectMonth,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
              decoration: BoxDecoration(
                color: const Color(0xFF1A2332),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: const Color(0xFF2D3748),
                  width: 1.5.w,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatMonth(selectedMonth),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: const Color(0xFF1A2332),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: const Color(0xFF3B82F6),
            width: 2.w,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Monthly Total Amount',
                    style: TextStyle(
                      color: const Color(0xFF9CA3AF),
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    _formatCurrency(totalAmount),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 1.w,
              height: 50.h,
              color: const Color(0xFF2D3748),
              margin: EdgeInsets.symmetric(horizontal: 16.w),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Total Meals',
                  style: TextStyle(
                    color: const Color(0xFF9CA3AF),
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  _formatNumber(totalMeals),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedBreakdownHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Detailed Breakdown',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${companies.length} Clients Found',
            style: TextStyle(
              color: const Color(0xFF6B7280),
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettlementTable() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A2332),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: const Color(0xFF2D3748),
            width: 1.5.w,
          ),
        ),
        child: Column(
          children: [
            // Table header
            _buildTableHeader(),

            // Divider
            Container(
              height: 1.h,
              color: const Color(0xFF2D3748),
            ),

            // Table rows
            ...companies.map((company) => _buildTableRow(company)).toList(),

            // Divider
            Container(
              height: 2.h,
              color: const Color(0xFF2D3748),
            ),

            // Total row
            _buildTotalRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              'COMPANY\nNAME',
              style: TextStyle(
                color: const Color(0xFF6B7280),
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'TOTAL\nMEALS',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF6B7280),
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'UNIT\nPRICE',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF6B7280),
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'TOTAL\nAMOUNT',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: const Color(0xFF6B7280),
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(CompanySettlement company) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  company.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  _formatNumber(company.totalMeals),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  _formatCurrency(company.unitPrice),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  _formatCurrency(company.totalAmount),
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 1.h,
          color: const Color(0xFF2D3748),
        ),
      ],
    );
  }

  Widget _buildTotalRow() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              'TOTAL',
              style: TextStyle(
                color: const Color(0xFF3B82F6),
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              _formatNumber(totalMeals),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF3B82F6),
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '-',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF3B82F6),
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              _formatCurrency(totalAmount),
              textAlign: TextAlign.right,
              style: TextStyle(
                color: const Color(0xFF3B82F6),
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExportButton() {
    final now = DateTime.now();
    final timestamp =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

    return Container(
      color: const Color(0xFF0F1419),
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: _exportToExcel,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 18.h),
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.download,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    '엑셀 다운로드 (Excel Export)',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'Generated on $timestamp',
            style: TextStyle(
              color: const Color(0xFF6B7280),
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class CompanySettlement {
  final String name;
  final int totalMeals;
  final int unitPrice;
  final int totalAmount;

  CompanySettlement({
    required this.name,
    required this.totalMeals,
    required this.unitPrice,
    required this.totalAmount,
  });
}
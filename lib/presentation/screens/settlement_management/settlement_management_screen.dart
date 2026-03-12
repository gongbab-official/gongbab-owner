import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:gongbab_owner/domain/entities/settlement/settlement.dart';
import 'package:gongbab_owner/presentation/router/app_router.dart';
import 'package:gongbab_owner/presentation/screens/settlement_detail/settlement_detail_screen.dart';
import 'package:gongbab_owner/presentation/screens/settlement_management/settlement_management_event.dart';
import 'package:gongbab_owner/presentation/screens/settlement_management/settlement_management_ui_state.dart';
import 'package:gongbab_owner/presentation/screens/settlement_management/settlement_management_view_model.dart';

class SettlementManagementScreen extends StatefulWidget {
  const SettlementManagementScreen({Key? key}) : super(key: key);

  @override
  State<SettlementManagementScreen> createState() =>
      _SettlementManagementScreenState();
}

class _SettlementManagementScreenState
    extends State<SettlementManagementScreen> {
  late SettlementManagementViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = GetIt.instance<SettlementManagementViewModel>();
    _viewModel.onEvent(const LoadSettlements());
  }

  void _navigateToDetail(Settlement settlement) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SettlementDetailScreen(
              year: settlement.year, month: settlement.month,),
      ),
    );
  }

  void _addNewSettlement() {
    context.push(AppRoutes.settlementRegister);
  }

  String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]},',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1419),
      appBar: _buildAppBar(),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          return Column(
            children: [
              // Header section
              _buildHeader(),

              // Settlement content
              Expanded(
                child: _buildContent(_viewModel.uiState),
              ),

              // Add new settlement button
              _buildAddButton(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContent(SettlementManagementUiState state) {
    if (state is SettlementManagementLoading) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF3B82F6)));
    }

    if (state is SettlementManagementError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              state.message,
              style: const TextStyle(color: Colors.white70),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () => _viewModel.onEvent(const LoadSettlements()),
              child: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    if (state is SettlementManagementSuccess) {
      final settlements = state.settlements;

      if (settlements.isEmpty) {
        return Center(
          child: Text(
            '정산 내역이 없습니다.',
            style: TextStyle(
              color: const Color(0xFF6B7280),
              fontSize: 16.sp,
            ),
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
        itemCount: settlements.length,
        itemBuilder: (context, index) {
          return _buildSettlementCard(settlements[index]);
        },
      );
    }

    return const SizedBox.shrink();
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF0F1419),
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => context.pop(),
      ),
      title: Text(
        '정산 관리',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '월별 정산 내역',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '최근 내역',
            style: TextStyle(
              color: const Color(0xFF6B7280),
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettlementCard(Settlement settlement) {
    final isConfirmed = settlement.status == 'CONFIRMED';

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(20.w),
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
          // Header row (Year, Month, Status)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${settlement.year}년',
                    style: TextStyle(
                      color: const Color(0xFF6B7280),
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${settlement.month}월 정산',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 8.h,
                ),
                decoration: BoxDecoration(
                  color: isConfirmed ? const Color(0xFF3B82F6) : const Color(0xFF2D3748),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  isConfirmed ? '확정됨' : '작성중',
                  style: TextStyle(
                    color: isConfirmed ? Colors.white : const Color(0xFF9CA3AF),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          // Divider
          Container(
            height: 1.h,
            color: const Color(0xFF2D3748),
          ),

          SizedBox(height: 16.h),

          // Company count
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '거래 기업',
                style: TextStyle(
                  color: const Color(0xFF6B7280),
                  fontSize: 14.sp,
                ),
              ),
              Text(
                '기업 ${settlement.companyCount ?? 0}개',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // Total amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '총 정산 금액',
                style: TextStyle(
                  color: const Color(0xFF6B7280),
                  fontSize: 14.sp,
                ),
              ),
              Text(
                '${_formatCurrency(settlement.totalSupplyAmount)}원',
                style: TextStyle(
                  color: const Color(0xFF3B82F6),
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Detail button
          GestureDetector(
            onTap: () => _navigateToDetail(settlement),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 14.h),
              decoration: BoxDecoration(
                color: const Color(0xFF2D3748),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '상세보기',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Icon(
                    Icons.chevron_right,
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

  Widget _buildAddButton() {
    return Container(
      padding: EdgeInsets.all(20.w),
      color: const Color(0xFF0F1419),
      child: GestureDetector(
        onTap: _addNewSettlement,
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
                Icons.add,
                color: Colors.white,
                size: 24.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                '새 정산 입력',
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
    );
  }
}
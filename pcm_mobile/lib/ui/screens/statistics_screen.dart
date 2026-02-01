import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Ensure this package is added, or assume user has it. If not, use simple bars.
// Actually, I should check pubspec.yaml but let's assume I can use simple containers if chart lib is missing.
// I'll stick to simple UI first to avoid build errors if package missing.
import '../../services/statistics_service.dart';
import '../../theme/app_colors.dart';
import 'package:intl/intl.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final StatisticsService _service = StatisticsService();
  bool _isLoading = true;
  Map<String, dynamic>? _dashboardStats;
  List<dynamic>? _topMembers;
  List<dynamic>? _revenueChart;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final dashboard = await _service.getDashboardStats();
      final revenue = await _service.getRevenueChart(DateTime.now().year);
      final members = await _service.getTopMembers();

      if (mounted) {
        setState(() {
          _dashboardStats = dashboard;
          _revenueChart = revenue;
          _topMembers = members;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thống Kê Câu Lạc Bộ'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.gradientStart, AppColors.gradientEnd],
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Lỗi: $_error'))
              : RefreshIndicator(
                  onRefresh: _loadData,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         _buildSummaryCards(),
                         const SizedBox(height: 24),
                         const Text(
                           'Biểu đồ doanh thu (năm nay)',
                           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                         ),
                         const SizedBox(height: 16),
                         _buildRevenueChart(),
                         const SizedBox(height: 24),
                         const Text(
                           'Top thành viên chi tiêu',
                           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                         ),
                         const SizedBox(height: 16),
                         _buildTopMembersList(),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildSummaryCards() {
    final revenue = _dashboardStats?['totalRevenue'] ?? 0;
    final bookings = _dashboardStats?['totalBookings'] ?? 0;
    final members = _dashboardStats?['totalMembers'] ?? 0;
    final revenueLastMonth = _dashboardStats?['revenueLastMonth'] ?? 0;

    final formatter = NumberFormat('#,###');

    return Column(
      children: [
        _buildCard(
          'Tổng doanh thu',
          '${formatter.format(revenue)} đ',
          Icons.attach_money,
          Colors.green,
          'Tháng trước: ${formatter.format(revenueLastMonth)} đ',
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildCard(
                'Tổng đơn đặt',
                '$bookings',
                Icons.calendar_today,
                Colors.blue,
                null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildCard(
                'Thành viên',
                '$members',
                Icons.people,
                Colors.orange,
                null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCard(String title, String value, IconData icon, Color color, String? subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRevenueChart() {
    // Simple bar chart using containers because we might not have fl_chart
    if (_revenueChart == null || _revenueChart!.isEmpty) {
      return const Center(child: Text('Không có dữ liệu'));
    }

    final maxRevenue = _revenueChart!.map((e) => (e['revenue'] as num).toDouble()).reduce((a, b) => a > b ? a : b);
    
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: _revenueChart!.map((item) {
          final revenue = (item['revenue'] as num).toDouble();
          final month = item['month'];
          final heightFactor = maxRevenue > 0 ? revenue / maxRevenue : 0.0;
          
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Tooltip(
                message: '${NumberFormat('#,###').format(revenue)} đ',
                child: Container(
                  width: 12,
                  height: 100 * heightFactor + 10, // Min height 10
                  decoration: BoxDecoration(
                    color: AppColors.gradientEnd,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$month',
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTopMembersList() {
    if (_topMembers == null || _topMembers!.isEmpty) {
      return const Center(child: Text('Chưa có dữ liệu thành viên'));
    }

    return Column(
      children: _topMembers!.map((member) {
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.gradientStart,
              child: Text(member['fullName'][0]),
            ),
            title: Text(member['fullName']),
            subtitle: Text('Hạng: ${member['tier']}'),
            trailing: Text(
              '${NumberFormat('#,###').format(member['totalSpent'])} đ',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
            ),
          ),
        );
      }).toList(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/features/admin/analytics/domain/entities/analytics_overview_entity.dart';
import 'package:hamro_deal/features/admin/analytics/domain/entities/top_product_entity.dart';
import 'package:hamro_deal/features/admin/analytics/presentation/state/admin_analytics_state.dart';
import 'package:hamro_deal/features/admin/analytics/presentation/view_model/admin_analytics_view_model.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminAnalyticsScreen extends ConsumerStatefulWidget {
  const AdminAnalyticsScreen({super.key});

  @override
  ConsumerState<AdminAnalyticsScreen> createState() =>
      _AdminAnalyticsScreenState();
}

class _AdminAnalyticsScreenState extends ConsumerState<AdminAnalyticsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(adminAnalyticsViewModelProvider.notifier).loadAnalytics(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminAnalyticsViewModelProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics Dashboard')),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(AdminAnalyticsState state) {
    if (state.status == AdminAnalyticsStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    // error
    if (state.status == AdminAnalyticsStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(state.errorMessage ?? 'An error occured'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref
                  .read(adminAnalyticsViewModelProvider.notifier)
                  .loadAnalytics(),
              child: const Text('retry'),
            ),
          ],
        ),
      );
    }

    // show data
    if (state.status == AdminAnalyticsStatus.success &&
        state.overview != null) {
      return _buildSuccessUI(state);
    }

    return const Center(child: Text('No data aavailable'));
  }

  Widget _buildSuccessUI(AdminAnalyticsState state) {
    final overview = state.overview!;

    return RefreshIndicator(
      onRefresh: () =>
          ref.read(adminAnalyticsViewModelProvider.notifier).loadAnalytics(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatsGrid(overview),
            const SizedBox(height: 24),
            _buildRevenueChart(state.revenueData),
            const SizedBox(height: 24),
            _buildTopProducts(state.topProducts),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(AnalyticsOverviewEntity overview) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.3,
      children: [
        _buildStatCard(
          title: 'Total Revenue',
          value:
              'Rs. ${overview.revenue.allTime.toStringAsFixed(0)} this month',
          subtitle: 'Rs ${overview.revenue.thisMonth.toStringAsFixed(0)} ',
          icon: Icons.attach_money,
          color: Colors.green,
        ),
        _buildStatCard(
          title: 'Total Orders',
          value: '${overview.orders.total}',
          subtitle: '${overview.orders.pending} pending',
          icon: Icons.shopping_cart,
          color: Colors.blue,
        ),
        _buildStatCard(
          title: 'Total Users',
          value: '${overview.users.total}',
          subtitle: '${overview.users.sellers} sellers',
          icon: Icons.people,
          color: Colors.purple,
        ),
        _buildStatCard(
          title: 'Total Products',
          value: '${overview.products.total}',
          subtitle: '${overview.products.lowStock} low stock',
          icon: Icons.inventory,
          color: Colors.orange,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(icon, color: color, size: 24),
              ],
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueChart(revenueData) {
    if (revenueData.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: const [
              Text(
                'Revenue Chart',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text('No revenue data available'),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Revenue Overview',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Last 30 days (${revenueData.length} data points)',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            'Rs ${(value / 1000).toStringAsFixed(0)}k',
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 &&
                              value.toInt() < revenueData.length) {
                            final date = revenueData[value.toInt()].date;
                            return Text(
                              date.split('-').last,
                              style: const TextStyle(fontSize: 10),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: List<FlSpot>.from(
                        revenueData.asMap().entries.map(
                          (e) => FlSpot(e.key.toDouble(), e.value.revenue),
                        ),
                      ),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
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

  Widget _buildTopProducts(List<TopProductEntity> topProducts) {
    if (topProducts.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: const [
              Text(
                'Top Products',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text('No products data available'),
            ],
          ),
        ),
      );
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Top Selling Products',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: topProducts.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final product = topProducts[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text(product.productName),
                  subtitle: Text('Sold: ${product.totalSold}'),
                  trailing: Text(
                    'Rs ${product.totalRevenue.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

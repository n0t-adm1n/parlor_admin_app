import 'package:flutter/material.dart';
import 'package:admin_app/services/export_service.dart';
import 'package:admin_app/widgets/kpi_card.dart';
import 'package:admin_app/widgets/transaction_tile.dart';

/// Dashboard tab – shows KPI summary cards, recent transactions list,
/// and a FAB to export bookings as CSV.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ExportService _exportService = ExportService();
  bool _isExporting = false;

  // ── Mock KPI data (replace with real Firestore streams) ────────────────────
  static const _kpiItems = [
    _KpiData(
      label: 'Revenue',
      value: '₹1,24,500',
      icon: Icons.currency_rupee_rounded,
      color: Color(0xFF10B981),
      trend: '+12.5%',
      trendUp: true,
    ),
    _KpiData(
      label: 'Bookings',
      value: '348',
      icon: Icons.calendar_month_rounded,
      color: Color(0xFF8B5CF6),
      trend: '+8.3%',
      trendUp: true,
    ),
    _KpiData(
      label: 'Active Parlors',
      value: '62',
      icon: Icons.storefront_rounded,
      color: Color(0xFF3B82F6),
      trend: '+3',
      trendUp: true,
    ),
    _KpiData(
      label: 'Pending Approvals',
      value: '14',
      icon: Icons.pending_actions_rounded,
      color: Color(0xFFF59E0B),
      trend: '-2',
      trendUp: false,
    ),
  ];

  // ── Mock transactions (replace with Firestore stream) ──────────────────────
  static const _transactions = [
    _TxData(
      parlorName: 'Glamour Studio',
      service: 'Bridal Makeup Package',
      amount: '₹8,500',
      status: 'Completed',
      date: 'Oct 22, 2026',
      avatarColor: Color(0xFF8B5CF6),
    ),
    _TxData(
      parlorName: 'Silk & Shine',
      service: 'Hair Spa + Colour',
      amount: '₹3,200',
      status: 'Completed',
      date: 'Oct 22, 2026',
      avatarColor: Color(0xFF10B981),
    ),
    _TxData(
      parlorName: 'The Beauty Bar',
      service: 'Full Body Waxing',
      amount: '₹1,800',
      status: 'Pending',
      date: 'Oct 21, 2026',
      avatarColor: Color(0xFFF59E0B),
    ),
    _TxData(
      parlorName: 'Radiance Salon',
      service: 'Keratin Treatment',
      amount: '₹5,600',
      status: 'Completed',
      date: 'Oct 21, 2026',
      avatarColor: Color(0xFF3B82F6),
    ),
    _TxData(
      parlorName: 'Bloom & Blush',
      service: 'Manicure + Pedicure',
      amount: '₹1,200',
      status: 'Cancelled',
      date: 'Oct 20, 2026',
      avatarColor: Color(0xFFEC4899),
    ),
    _TxData(
      parlorName: 'Urban Glow',
      service: 'Facial (Gold)',
      amount: '₹2,400',
      status: 'Completed',
      date: 'Oct 20, 2026',
      avatarColor: Color(0xFF06B6D4),
    ),
  ];

  Future<void> _handleExport() async {
    setState(() => _isExporting = true);
    try {
      await _exportService.exportBookingsToCsv();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0F0B1E),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isExporting ? null : _handleExport,
        icon: _isExporting
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.download_rounded),
        label: Text(_isExporting ? 'Exporting…' : 'Export CSV'),
        backgroundColor: const Color(0xFF8B5CF6),
        foregroundColor: Colors.white,
        elevation: 6,
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── App Bar ────────────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: const Color(0xFF0F0B1E),
            expandedHeight: 100,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Admin Dashboard',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Beauty Parlor Marketplace',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white54,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16, top: 8),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: const Color(0xFF8B5CF6).withValues(alpha: 0.2),
                  child: const Icon(
                    Icons.admin_panel_settings_rounded,
                    color: Color(0xFF8B5CF6),
                    size: 20,
                  ),
                ),
              ),
            ],
          ),

          // ── KPI 2×2 Grid ───────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(title: 'Overview', subtitle: 'This month'),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _kpiItems.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.4,
                    ),
                    itemBuilder: (context, index) {
                      final item = _kpiItems[index];
                      return KpiCard(
                        label: item.label,
                        value: item.value,
                        icon: item.icon,
                        accentColor: item.color,
                        trend: item.trend,
                        trendUp: item.trendUp,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // ── Recent Transactions ────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(
                    title: 'Recent Transactions',
                    subtitle: '${_transactions.length} today',
                    actionLabel: 'See all',
                    onAction: () {},
                  ),
                  const SizedBox(height: 12),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _transactions.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final tx = _transactions[index];
                      return TransactionTile(
                        parlorName: tx.parlorName,
                        service: tx.service,
                        amount: tx.amount,
                        status: tx.status,
                        date: tx.date,
                        avatarColor: tx.avatarColor,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Private data holders ─────────────────────────────────────────────────────

class _KpiData {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String trend;
  final bool trendUp;

  const _KpiData({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.trend,
    required this.trendUp,
  });
}

class _TxData {
  final String parlorName;
  final String service;
  final String amount;
  final String status;
  final String date;
  final Color avatarColor;

  const _TxData({
    required this.parlorName,
    required this.service,
    required this.amount,
    required this.status,
    required this.date,
    required this.avatarColor,
  });
}

// ── Section header widget ─────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.white38, fontSize: 12),
            ),
          ],
        ),
        if (actionLabel != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionLabel!,
              style: const TextStyle(
                color: Color(0xFF8B5CF6),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
      ],
    );
  }
}

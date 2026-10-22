import 'package:flutter/material.dart';

/// A single row in the Recent Transactions list.
class TransactionTile extends StatelessWidget {
  final String parlorName;
  final String service;
  final String amount;
  final String status;
  final String date;
  final Color avatarColor;

  const TransactionTile({
    super.key,
    required this.parlorName,
    required this.service,
    required this.amount,
    required this.status,
    required this.date,
    required this.avatarColor,
  });

  Color get _statusColor {
    switch (status.toLowerCase()) {
      case 'completed':
        return const Color(0xFF10B981);
      case 'pending':
        return const Color(0xFFF59E0B);
      case 'cancelled':
        return const Color(0xFFF87171);
      default:
        return Colors.white54;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1330),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        // Avatar with parlor initial
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: avatarColor.withValues(alpha: 0.18),
          child: Text(
            parlorName.isNotEmpty ? parlorName[0].toUpperCase() : '?',
            style: TextStyle(
              color: avatarColor,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
        ),
        // Parlor name + service
        title: Text(
          parlorName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          service,
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 12,
          ),
        ),
        // Amount + status pill + date
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              amount,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: _statusColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: _statusColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              date,
              style: const TextStyle(color: Colors.white24, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

/// Placeholder screen for the Parlors management tab.
class ParlorsScreen extends StatelessWidget {
  const ParlorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0B1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0B1E),
        title: const Text(
          'Parlors',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        elevation: 0,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.storefront_rounded,
              size: 64,
              color: Color(0xFF3B82F6),
            ),
            SizedBox(height: 16),
            Text(
              'Parlors Management',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Coming soon — list & manage\nall registered parlors here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white38, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

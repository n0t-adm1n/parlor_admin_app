import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Service responsible for exporting Firestore booking data as a CSV file
/// and sharing it via the native share sheet.
class ExportService {
  final FirebaseFirestore _firestore;

  ExportService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Fetches all documents from the 'bookings' collection, converts them to
  /// CSV format, writes the result to a temporary file, and triggers the
  /// platform share sheet so the user can save or send the export.
  Future<void> exportBookingsToCsv() async {
    // 1. Fetch all bookings from Firestore
    final QuerySnapshot snapshot =
        await _firestore.collection('bookings').get();

    // 2. Build rows: header + data rows
    final List<List<dynamic>> rows = [
      // Header row
      ['Booking ID', 'Date', 'Parlor Name', 'Total Price', 'Status'],
    ];

    for (final QueryDocumentSnapshot doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;

      // Safely read each field; fall back to empty string if missing
      final String bookingId = doc.id;
      final dynamic rawDate = data['date'];
      final String date = rawDate is Timestamp
          ? rawDate.toDate().toIso8601String()
          : (rawDate?.toString() ?? '');
      final String parlorName = (data['parlorName'] ?? '').toString();
      final dynamic rawPrice = data['totalPrice'];
      final String totalPrice = rawPrice != null ? rawPrice.toString() : '0';
      final String status = (data['status'] ?? '').toString();

      rows.add([bookingId, date, parlorName, totalPrice, status]);
    }

    // 3. Convert to CSV string using csv 8.x CsvEncoder
    final String csvString = const CsvEncoder().convert(rows);

    // 4. Write CSV to a temporary file
    final Directory tempDir = await getTemporaryDirectory();
    final String filePath = '${tempDir.path}/bookings_export.csv';
    final File csvFile = File(filePath);
    await csvFile.writeAsString(csvString);

    // 5. Trigger platform share sheet (share_plus 13.x API)
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(filePath, mimeType: 'text/csv')],
        subject: 'Bookings Export',
        text: 'Please find the bookings export attached.',
      ),
    );
  }
}

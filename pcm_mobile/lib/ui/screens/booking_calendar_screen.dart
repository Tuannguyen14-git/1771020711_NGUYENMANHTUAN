import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/booking_provider.dart';
import '../../providers/court_provider.dart';
import '../../models/booking.dart';
import '../../models/court.dart';

class BookingCalendarScreen extends StatelessWidget {
  const BookingCalendarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);
    final courtProvider = Provider.of<CourtProvider>(context);
    // TODO: Sử dụng table_calendar hoặc syncfusion_flutter_calendar để hiển thị lịch
    return Scaffold(
      appBar: AppBar(title: const Text('Lịch đặt sân')),
      body: Center(child: Text('Lịch đặt sân sẽ hiển thị ở đây')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Mở form đặt sân
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

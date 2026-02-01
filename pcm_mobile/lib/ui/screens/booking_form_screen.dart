import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/booking_provider.dart';
import '../../providers/court_provider.dart';

class BookingFormScreen extends StatefulWidget {
  const BookingFormScreen({Key? key}) : super(key: key);

  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  int? selectedCourtId;
  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  @override
  Widget build(BuildContext context) {
    final courtProvider = Provider.of<CourtProvider>(context);
    final bookingProvider = Provider.of<BookingProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Đặt sân')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(labelText: 'Chọn sân'),
              items: courtProvider.courts
                  .map(
                    (court) => DropdownMenuItem(
                      value: court.id,
                      child: Text(court.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => selectedCourtId = value),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Chọn ngày'),
              readOnly: true,
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) setState(() => selectedDate = picked);
              },
              controller: TextEditingController(
                text: selectedDate != null
                    ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                    : '',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Giờ bắt đầu'),
                    readOnly: true,
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (picked != null) setState(() => startTime = picked);
                    },
                    controller: TextEditingController(
                      text: startTime != null ? startTime!.format(context) : '',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Giờ kết thúc',
                    ),
                    readOnly: true,
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (picked != null) setState(() => endTime = picked);
                    },
                    controller: TextEditingController(
                      text: endTime != null ? endTime!.format(context) : '',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            bookingProvider.isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      if (selectedCourtId == null ||
                          selectedDate == null ||
                          startTime == null ||
                          endTime == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Vui lòng nhập đầy đủ thông tin'),
                          ),
                        );
                        return;
                      }
                      final startDateTime = DateTime(
                        selectedDate!.year,
                        selectedDate!.month,
                        selectedDate!.day,
                        startTime!.hour,
                        startTime!.minute,
                      );
                      final endDateTime = DateTime(
                        selectedDate!.year,
                        selectedDate!.month,
                        selectedDate!.day,
                        endTime!.hour,
                        endTime!.minute,
                      );
                      await bookingProvider.createBooking({
                        'courtId': selectedCourtId,
                        'startTime': startDateTime.toIso8601String(),
                        'endTime': endDateTime.toIso8601String(),
                      });
                      if (bookingProvider.error != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(bookingProvider.error!)),
                        );
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Xác nhận đặt sân'),
                  ),
          ],
        ),
      ),
    );
  }
}

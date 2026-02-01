import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../services/booking_service.dart';
import '../../providers/auth_provider.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final BookingService _bookingService = BookingService();
  
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  int? _selectedCourtId;
  
  List<dynamic> _courts = [];
  List<dynamic> _bookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    try {
      // 1. Fetch Courts
      final courts = await _bookingService.getCourts();
      
      // 2. Fetch Bookings (Month)
      await _fetchBookings();

      if (mounted) {
        setState(() {
          _courts = courts;
          if (_courts.isNotEmpty) {
            _selectedCourtId = _courts[0]['id'];
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _fetchBookings() async {
    if (_selectedDay == null) return;

    // Get range for the week/month.Ideally query API for the needed range.
    // For simplicity, let's just query a wide range around the selected day.
    final from = _selectedDay!.subtract(const Duration(days: 7));
    final to = _selectedDay!.add(const Duration(days: 7));

    try {
      final results = await _bookingService.getCalendar(from, to);
      setState(() {
        _bookings = results;
      });
    } catch (e) {
      debugPrint('Error fetching bookings: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Đặt sân', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.gradientStart,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.gradientStart, AppColors.gradientEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
             onPressed: _fetchInitialData,
          )
        ],
      ),
      body: Column(
        children: [
          _buildCalendar(),
          const SizedBox(height: 10),
          _buildCourtSelector(),
          const Divider(),
          _buildLegend(),
          const Divider(),
          Expanded(
            child: _buildTimeSlots(),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      firstDay: DateTime.now().subtract(const Duration(days: 1)),
      lastDay: DateTime.now().add(const Duration(days: 30)),
      focusedDay: _focusedDay,
      calendarFormat: CalendarFormat.week,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(_selectedDay, selectedDay)) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
          _fetchBookings();
        }
      },
      calendarStyle: const CalendarStyle(
        selectedDecoration: BoxDecoration(
          color: AppColors.gradientEnd,
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          color: AppColors.gradientStart,
          shape: BoxShape.circle,
        ),
      ),
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
    );
  }

  Widget _buildCourtSelector() {
    if (_courts.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 50,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _courts.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final court = _courts[index];
          final isSelected = _selectedCourtId == court['id'];
          return ChoiceChip(
            label: Text(court['name']),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) {
                setState(() {
                  _selectedCourtId = court['id'];
                });
              }
            },
            selectedColor: AppColors.gradientStart,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildLegend() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _legendItem(Colors.green, 'Của bạn'),
          _legendItem(Colors.redAccent, 'Đã đặt'),
          _legendItem(Colors.grey.shade300, 'Trống'),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildTimeSlots() {
    if (_selectedCourtId == null || _selectedDay == null) {
      return const Center(child: Text("Vui lòng chọn sân và ngày"));
    }

    // Generate slots from 06:00 to 22:00
    final slots = List.generate(17, (index) {
      final hour = 6 + index;
      final startTime = DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day, hour);
      final endTime = startTime.add(const Duration(hours: 1));
      
      final timeStr = '${hour.toString().padLeft(2, '0')}:00';
      
      // Check status against _bookings
      // Status: 0=Empty, 1=Mine, 2=Booked
      int status = 0;
      
      // Filter bookings for this court and overlapping time
      final overlapping = _bookings.where((b) {
        if (b['courtId'] != _selectedCourtId) return false;
        
        final bStart = DateTime.parse(b['startTime']);
        final bEnd = DateTime.parse(b['endTime']);
        // Overlap logic: Start < bEnd && End > bStart
        return startTime.isBefore(bEnd) && endTime.isAfter(bStart) && b['status'] != 2; // Not cancelled
      }).toList();

      final currentUser = context.read<AuthProvider>().user;
      
      if (overlapping.isNotEmpty) {
        // Check if mine
        final isMine = overlapping.any((b) => b['memberId'] == currentUser?.id);
        status = isMine ? 1 : 2;
      }

      return {'time': timeStr, 'status': status, 'price': '100k', 'start': startTime, 'end': endTime};
    });

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: slots.length,
      itemBuilder: (context, index) {
        final slot = slots[index];
        final status = slot['status'] as int;
        
        Color bgColor;
        Color textColor;
        
        switch (status) {
          case 1: // Mine
            bgColor = Colors.green;
            textColor = Colors.white;
            break;
          case 2: // Booked
            bgColor = Colors.redAccent;
            textColor = Colors.white;
            break;
          default: // Empty
            bgColor = Colors.white;
            textColor = Colors.black;
        }

        return InkWell(
          onTap: status == 0 ? () => _showBookingBottomSheet(context, slot) : null,
          child: Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                 if (status == 0)
                   BoxShadow(
                     color: Colors.grey.withOpacity(0.1),
                     blurRadius: 4,
                     offset: const Offset(0, 2),
                   )
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  slot['time'] as String,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                if (status == 0)
                  Text(
                    slot['price'] as String,
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                 if (status == 1)
                   const Icon(Icons.check, size: 16, color: Colors.white),
                 if (status == 2)
                   const Icon(Icons.lock, size: 16, color: Colors.white),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showBookingBottomSheet(BuildContext context, Map<String, dynamic> slot) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        bool processing = false;
        
        return StatefulBuilder(
          builder: (context, setStateSheet) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    'Xác nhận đặt sân',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  _infoRow(Icons.calendar_today, DateFormat('dd/MM/yyyy').format(slot['start'])),
                  _infoRow(Icons.access_time, slot['time']),
                  _infoRow(Icons.stadium, 'Sân $_selectedCourtId'),
                  _infoRow(Icons.monetization_on, '100.000 đ'), // In real app, get price from Court object
                  const SizedBox(height: 24),
                  
                  if (processing)
                    const Center(child: CircularProgressIndicator())
                  else
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          setStateSheet(() => processing = true);
                          
                          try {
                            // 1. Hold
                            final user = context.read<AuthProvider>().user;
                            final startTime = slot['start'] as DateTime;
                            final endTime = slot['end'] as DateTime;

                            // Direct confirm for simplicity (skipping HOLD step for now to save time, or do both?)
                            // Let's do direct confirm logic directly via 'hold' then 'confirm' if needed, but endpoint Create is enough normally.
                            // The controller has Create(BookingCreateDto). Let's use Create.
                            
                            final dto = {
                              'courtId': _selectedCourtId,
                              'memberId': user?.id,
                              'startTime': startTime.toIso8601String(),
                              'endTime': endTime.toIso8601String(),
                            };

                            // 1. Hold
                            final holdRes = await _bookingService.holdSlot(dto);
                            final bookingId = holdRes['bookingId'];
                            
                            // 2. Confirm
                            await _bookingService.confirmBooking({
                               'bookingId': bookingId,
                               'memberId': user?.id,
                            });

                            if (!context.mounted) return;
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Đặt sân thành công!')),
                            );
                            _fetchBookings(); // Refresh
                            
                            // Update Wallet Balance locally
                            // (Ideally fetch profile again)
                            
                          } catch (e) {
                            if (!context.mounted) return;
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.gradientEnd,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Thanh toán & Đặt sân'),
                      ),
                    )
                ],
              ),
            );
          }
        );
      },
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

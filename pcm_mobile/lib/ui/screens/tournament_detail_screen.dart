import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class TournamentDetailScreen extends StatelessWidget {
  const TournamentDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết giải đấu', style: TextStyle(color: Colors.white)),
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
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner
            Container(
              height: 150,
              width: double.infinity,
              color: Colors.grey.shade300,
              child: const Center(child: Icon(Icons.image, size: 60, color: Colors.grey)),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Giải Pickleball Mở Rộng 2026',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('Mô tả: Giải đấu dành cho các vận động viên phong trào khu vực Phố Núi...'),
                  const SizedBox(height: 20),
                  
                  // JOIN BUTTON
                  SizedBox(
                    width: double.infinity,
                     height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // Check wallet -> Join API
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.gradientEnd,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('ĐĂNG KÝ THAM GIA NGAY'),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  const Text(
                    'Nhánh đấu (Bracket)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  
                  // BRACKET VISUALIZER
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: 600,
                      height: 400,
                      child: CustomPaint(
                        painter: BracketPainter(),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showJoinDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận'),
        content: const Text(
          'Bạn có chắc muốn đăng ký tham gia giải đấu này?\n\n'
          'Phí tham gia: 200,000 đ sẽ được trừ từ ví của bạn.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Đăng ký thành công! Backend chưa có API này.'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.gradientEnd,
            ),
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );
  }
}

// Simple Bracket Painter
class BracketPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final textStyle = const TextStyle(color: Colors.black, fontSize: 12);

    // Coordinates logic can be complex, drawing a simple Semi-Final -> Final shape
    // Round 1 (4 Teams) -> 2 Matches
    // Match 1: Team A vs Team B
    _drawMatch(canvas, paint, 50, 50, 'Team A', 'Team B');
    // Match 2: Team C vs Team D
    _drawMatch(canvas, paint, 50, 250, 'Team C', 'Team D');

    // Round 2 (Final) -> Winner 1 vs Winner 2
    _drawMatch(canvas, paint, 250, 150, 'Winner 1', 'Winner 2');

    // Winner
    _drawBox(canvas, 450, 150, 'CHAMPION');

    // Connections
    // Match 1 to Final
    canvas.drawLine(const Offset(150, 80), const Offset(200, 80), paint); // Horizontal
    canvas.drawLine(const Offset(200, 80), const Offset(200, 180), paint); // Vertical down to Final
    canvas.drawLine(const Offset(200, 180), const Offset(250, 180), paint); // Horizontal to Final

    // Match 2 to Final
    canvas.drawLine(const Offset(150, 280), const Offset(200, 280), paint); // Horizontal
    canvas.drawLine(const Offset(200, 280), const Offset(200, 180), paint); // Vertical up to Final
    // (Line to final is shared above)
    
    // Final to Champion
    canvas.drawLine(const Offset(350, 180), const Offset(450, 180), paint);
  }

  void _drawMatch(Canvas canvas, Paint paint, double x, double y, String t1, String t2) {
    // Draw Box
    final w = 100.0;
    final h = 60.0;
    final r = 8.0;

    final rect = RRect.fromRectAndRadius(Rect.fromLTWH(x, y, w, h), Radius.circular(r));
    canvas.drawRRect(rect, paint);
    
    // Draw Divider
    canvas.drawLine(Offset(x, y + h/2), Offset(x + w, y + h/2), paint);

    // Text
    _drawText(canvas, x + 10, y + 10, t1);
    _drawText(canvas, x + 10, y + 10 + h/2, t2);
  }

  void _drawBox(Canvas canvas, double x, double y, String text) {
     final paint = Paint()
      ..color = AppColors.gold
      ..style = PaintingStyle.fill;
     
     final rect = RRect.fromRectAndRadius(Rect.fromLTWH(x, y, 100, 40), const Radius.circular(8));
     canvas.drawRRect(rect, paint);
     
     _drawText(canvas, x + 10, y + 12, text, color: Colors.white, bold: true);
  }

  void _drawText(Canvas canvas, double x, double y, String text, {Color color = Colors.black, bool bold = false}) {
    final textSpan = TextSpan(
      text: text,
      style: TextStyle(color: color, fontSize: 12, fontWeight: bold ? FontWeight.bold : FontWeight.normal),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(minWidth: 0, maxWidth: 100);
    textPainter.paint(canvas, Offset(x, y));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

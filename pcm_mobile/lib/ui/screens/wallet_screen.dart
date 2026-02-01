import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/wallet_service.dart';
import 'package:intl/intl.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final WalletService _walletService = WalletService();
  List<dynamic> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    final user = context.read<AuthProvider>().user;
    if (user == null) return;

    try {
      final data = await _walletService.getTransactions(user.id);
      if (mounted) {
        setState(() {
          _transactions = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        // Silent error or snackbar
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final balanceFormatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ví của tôi', style: TextStyle(color: Colors.white)),
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
      body: Column(
        children: [
          // BALANCE CARD
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text('Số dư hiện tại', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                Text(
                  balanceFormatter.format(user?.walletBalance ?? 0),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.gradientEnd,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () => _showDepositSheet(context),
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text('NẠP TIỀN VÀO VÍ'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryIcon,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Lịch sử giao dịch',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(icon: const Icon(Icons.refresh), onPressed: _fetchTransactions),
              ],
            ),
          ),
          
          // TRANSACTION LIST
          Expanded(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator())
              : _transactions.isEmpty 
                  ? const Center(child: Text("Chưa có giao dịch nào"))
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _transactions.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final tx = _transactions[index];
                        // tx fields: amount, type (0=Deposit, 1=Payment, 2=Refund), description, createdDate
                        final type = tx['type'] as int;
                        final amount = (tx['amount'] as num).toDouble();
                        final isPlus = amount > 0;
                        final createdDate = DateTime.parse(tx['createdDate']);
                        
                        IconData icon;
                        Color color;
                        String typeStr;

                        switch (type) {
                          case 0: // Deposit
                            icon = Icons.arrow_downward;
                            color = Colors.green;
                            typeStr = 'Nạp tiền';
                            break;
                          case 1: // Payment
                            icon = Icons.payment;
                            color = Colors.red;
                            typeStr = 'Thanh toán';
                            break;
                          case 2: // Refund
                            icon = Icons.refresh;
                            color = Colors.blue;
                            typeStr = 'Hoàn tiền';
                            break;
                          default:
                            icon = Icons.attach_money;
                            color = Colors.grey;
                            typeStr = 'Giao dịch';
                        }
                        
                        return ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(icon, color: color),
                          ),
                          title: Text(tx['description'] ?? typeStr),
                          subtitle: Text(DateFormat('dd/MM/yyyy HH:mm').format(createdDate)),
                          trailing: Text(
                            '${isPlus ? '+' : ''}${balanceFormatter.format(amount)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isPlus ? Colors.green : Colors.red,
                              fontSize: 16,
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  void _showDepositSheet(BuildContext context) {
    final amountController = TextEditingController();
    bool isProcessing = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setStateSheet) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
                left: 24,
                right: 24,
                top: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nạp tiền',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Số tiền muốn nạp',
                      border: OutlineInputBorder(),
                      suffixText: 'VNĐ',
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Mock Image Upload UI
                  Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         Icon(Icons.upload_file, color: Colors.grey),
                         Text('Tải ảnh chuyển khoản (Bill) - Mock'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  if (isProcessing)
                    const Center(child: CircularProgressIndicator())
                  else
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          final amount = double.tryParse(amountController.text);
                          if (amount == null || amount <= 0) {
                             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Số tiền không hợp lệ')));
                             return;
                          }

                          setStateSheet(() => isProcessing = true);

                          try {
                            // Call API
                            final user = context.read<AuthProvider>().user;
                            await _walletService.deposit({
                              'memberId': user?.id,
                              'amount': amount,
                              'description': 'Nạp tiền qua App (Demo)'
                            });
                            
                            // Refresh User Profile to show new balance
                            await context.read<AuthProvider>().tryAutoLogin();

                            if (!context.mounted) return;
                            Navigator.pop(ctx);
                            _fetchTransactions(); // Refresh list
                             ScaffoldMessenger.of(context).showSnackBar(
                               const SnackBar(content: Text('Nạp tiền thành công!')),
                             );

                          } catch (e) {
                             if (!context.mounted) return;
                             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
                             setStateSheet(() => isProcessing = false);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.gradientEnd,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Xác nhận'),
                      ),
                    ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          }
        );
      },
    );
  }
}

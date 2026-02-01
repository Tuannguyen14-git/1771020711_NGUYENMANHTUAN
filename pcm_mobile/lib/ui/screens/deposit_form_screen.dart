import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/wallet_provider.dart';

class DepositFormScreen extends StatefulWidget {
  const DepositFormScreen({Key? key}) : super(key: key);

  @override
  State<DepositFormScreen> createState() => _DepositFormScreenState();
}

class _DepositFormScreenState extends State<DepositFormScreen> {
  final _amountController = TextEditingController();
  String? imagePath;

  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Nạp tiền vào ví')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Số tiền nạp'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // TODO: Chọn ảnh chuyển khoản bằng image_picker
              },
              child: const Text('Chọn ảnh chuyển khoản'),
            ),
            const SizedBox(height: 24),
            walletProvider.isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      if (_amountController.text.isEmpty || imagePath == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Vui lòng nhập số tiền và chọn ảnh'),
                          ),
                        );
                        return;
                      }
                      await walletProvider.deposit(
                        double.parse(_amountController.text),
                        imagePath!,
                      );
                      if (walletProvider.error != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(walletProvider.error!)),
                        );
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Xác nhận nạp tiền'),
                  ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../theme/colors.dart';

class ConnectGuardianScreen extends StatelessWidget {
  const ConnectGuardianScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 30, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
            const SizedBox(width: 4),
            Container(width: 30, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
            const SizedBox(width: 4),
            Container(width: 30, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
            const SizedBox(width: 4),
            Container(width: 30, height: 4, decoration: BoxDecoration(color: AppColors.primaryBlue, borderRadius: BorderRadius.circular(2))),
          ],
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Lewati', style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Mascot
            Container(
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.blue.shade300, Colors.blue.shade500],
                ),
              ),
              child: Center(child: Image.asset('assets/icon/icon1.png', height: 100)),
            ),
            const SizedBox(height: 24),
            
            const Text(
              'Hubungkan Guardian',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(color: Colors.grey.shade700, fontSize: 14, height: 1.5),
                children: const [
                  TextSpan(text: 'Guardian menerima peringatan keamanan dan ringkasan progres untuk membantumu, namun '),
                  TextSpan(text: 'tidak dapat membaca isi percakapan pribadimu', style: TextStyle(color: AppColors.primaryBlue)),
                  TextSpan(text: '.'),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Instructions Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.indigo.shade100.withValues(alpha: 0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.telegram, color: AppColors.primaryBlue, size: 20),
                      SizedBox(width: 8),
                      Text('Cara Menghubungkan Telegram', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildInstructionStep('1', 'Buka bot Telegram @MoniyBot', button: 'Buka Telegram', showLine: true),
                  _buildInstructionStep('2', 'Ketik /start di chat bot tersebut', showLine: true),
                  _buildInstructionStep('3', 'Salin ID Telegram yang diberikan bot, lalu masukkan di bawah ini.', showLine: false),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Form Fields
            const Text('Nama Guardian (Contoh: Ayah, Kakak)', style: TextStyle(fontSize: 12, color: Colors.black87)),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: 'Masukkan nama Guardian',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                prefixIcon: Icon(LucideIcons.user, color: Colors.grey.shade400, size: 20),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primaryBlue)),
              ),
            ),
            const SizedBox(height: 16),
            
            const Text('ID Telegram Guardian', style: TextStyle(fontSize: 12, color: Colors.black87)),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: 'Contoh: 123456789',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                prefixIcon: Icon(LucideIcons.hash, color: Colors.grey.shade400, size: 20),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primaryBlue)),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(LucideIcons.info, size: 12, color: Colors.grey.shade500),
                const SizedBox(width: 4),
                Text('Pastikan ID angka, bukan username (@).', style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
              ],
            ),
            const SizedBox(height: 24),
            
            // Security Info
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.cyanAccent.shade100.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(LucideIcons.shieldCheck, size: 14, color: Colors.teal),
                  SizedBox(width: 6),
                  Text('Data Guardian dilindungi dengan enkripsi aman', style: TextStyle(color: Colors.teal, fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Submit Button
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(LucideIcons.link2, size: 18),
              label: const Text('Hubungkan Guardian', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F172A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionStep(String number, String text, {String? button, required bool showLine}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.indigo.shade100,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(number, style: TextStyle(color: Colors.indigo.shade700, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ),
              if (showLine)
                Expanded(
                  child: Container(
                    width: 1,
                    color: Colors.grey.shade300,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black87, fontSize: 13),
                      children: _parseInstructionText(text),
                    ),
                  ),
                  if (button != null) ...[
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(LucideIcons.externalLink, size: 12),
                      label: Text(button, style: const TextStyle(fontSize: 12)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryBlue,
                        side: BorderSide(color: AppColors.primaryBlue.withValues(alpha: 0.5)),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                        minimumSize: const Size(0, 32),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<TextSpan> _parseInstructionText(String text) {
    if (text.contains('@MoniyBot')) {
      final parts = text.split('@MoniyBot');
      return [
        TextSpan(text: parts[0]),
        const TextSpan(text: '@MoniyBot', style: TextStyle(color: AppColors.primaryBlue)),
        TextSpan(text: parts[1]),
      ];
    } else if (text.contains('/start')) {
      final parts = text.split('/start');
      return [
        TextSpan(text: parts[0]),
        TextSpan(
          text: '/start',
          style: TextStyle(backgroundColor: Colors.grey.shade200, fontFamily: 'monospace', color: Colors.black87),
        ),
        TextSpan(text: parts[1]),
      ];
    }
    return [TextSpan(text: text)];
  }
}

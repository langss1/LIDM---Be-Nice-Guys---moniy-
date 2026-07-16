import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../theme/colors.dart';

class ModuleWarningScreen extends StatelessWidget {
  const ModuleWarningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F5), // Light pinkish background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.x, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.red.shade100,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(LucideIcons.alertTriangle, size: 14, color: Colors.red.shade700),
              const SizedBox(width: 4),
              Text('Perhatian', style: TextStyle(color: Colors.red.shade700, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Mascot
            Container(
              height: 180,
              width: 180,
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.blue.shade100, Colors.blue.shade300],
                ),
              ),
              child: const Center(child: Icon(LucideIcons.bot, size: 80, color: Colors.white)),
            ),
            const SizedBox(height: 32),
            
            const Text(
              'Keuanganmu mulai berisiko',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Keputusan terakhirmu menggunakan persentase tabungan yang terlalu besar untuk aktivitas dengan peluang hasil yang tidak pasti. Ini mirip dengan pola spekulasi yang berbahaya.',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.6),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            // Mitigasi Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: Colors.blue.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 10)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppColors.primaryBlue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(LucideIcons.shield, color: Colors.white, size: 18),
                      ),
                      const SizedBox(width: 12),
                      const Text('Tips Mitigasi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildTipItem('Batasi pengeluaran non-esensial maksimal 20% dari total dana.'),
                  const SizedBox(height: 16),
                  _buildTipItem('Pisahkan rekening tabungan utama dari dana operasional harian.'),
                  const SizedBox(height: 16),
                  _buildTipItem('Evaluasi kembali risiko sebelum mengambil keputusan finansial besar.'),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(LucideIcons.rotateCcw, size: 18),
              label: const Text('Ulangi dari checkpoint', style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryBlue,
                side: const BorderSide(color: AppColors.primaryBlue),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Pelajari keputusan ini', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(LucideIcons.checkCircle2, color: AppColors.primaryBlue, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text, style: TextStyle(color: Colors.grey.shade800, fontSize: 13, height: 1.4)),
        ),
      ],
    );
  }
}

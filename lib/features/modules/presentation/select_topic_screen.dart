import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../theme/colors.dart';

class SelectTopicScreen extends StatelessWidget {
  const SelectTopicScreen({super.key});

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
        title: const Text(
          'Moniy',
          style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.x, color: AppColors.primaryBlue),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Step indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStep(1, 'Topik', isActive: true),
                _buildStepDivider(),
                _buildStep(2, 'Detail'),
                _buildStepDivider(),
                _buildStep(3, 'Preview'),
              ],
            ),
            const SizedBox(height: 32),
            
            const Text(
              'Pilih Topik Modul',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Pilih area fokus untuk modul yang ingin kamu buat hari ini.',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            
            _buildTopicCard(
              icon: LucideIcons.wallet,
              iconBgColor: Colors.teal.shade100,
              iconColor: Colors.teal.shade700,
              title: 'Budgeting Dasar',
              description: 'Pelajari cara mengelola uang saku dan merencanakan pengeluaran dengan bijak.',
              isSelected: true,
            ),
            const SizedBox(height: 16),
            _buildTopicCard(
              icon: LucideIcons.trendingUp,
              iconBgColor: Colors.blue.shade100,
              iconColor: Colors.blue.shade700,
              title: 'Mulai Investasi',
              description: 'Pahami konsep dasar investasi yang aman untuk pemula dan jangka panjang.',
            ),
            const SizedBox(height: 16),
            _buildTopicCard(
              icon: LucideIcons.shieldAlert,
              iconBgColor: Colors.red.shade100,
              iconColor: Colors.red.shade700,
              title: 'Risiko Online & Keamanan',
              description: 'Kenali bahaya judi online, penipuan digital, dan cara melindungi dirimu.',
            ),
            const SizedBox(height: 16),
            _buildTopicCard(
              icon: LucideIcons.piggyBank,
              iconBgColor: Colors.indigo.shade100,
              iconColor: Colors.indigo.shade700,
              title: 'Target Menabung',
              description: 'Strategi jitu untuk mencapai tujuan finansial jangka pendek atau panjang.',
            ),
            const SizedBox(height: 32),
            
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('Lanjut', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(width: 8),
                    Icon(LucideIcons.arrowRight, size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(int number, String label, {bool isActive = false}) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryBlue : Colors.grey.shade200,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number.toString(),
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey.shade600,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isActive ? AppColors.primaryBlue : Colors.grey.shade500,
            fontSize: 10,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStepDivider() {
    return Container(
      width: 40,
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      color: Colors.grey.shade200,
    );
  }

  Widget _buildTopicCard({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String description,
    bool isSelected = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isSelected ? AppColors.primaryBlue : Colors.grey.shade200, width: isSelected ? 2 : 1),
        boxShadow: isSelected
            ? [BoxShadow(color: AppColors.primaryBlue.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4))]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          Text(description, style: TextStyle(color: Colors.grey.shade600, fontSize: 12, height: 1.4)),
        ],
      ),
    );
  }
}

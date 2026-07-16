import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Pusat Bantuan',
          style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(LucideIcons.helpCircle, size: 80, color: Colors.blue),
            const SizedBox(height: 16),
            Text(
              'Ada yang bisa kami bantu?',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            _buildFAQItem('Bagaimana cara mendapatkan Badge?', 'Anda bisa mendapatkan badge dengan menyelesaikan modul, menjaga streak berturut-turut, atau meraih poin tertentu.'),
            const SizedBox(height: 12),
            _buildFAQItem('Bagaimana cara membuat Grup?', 'Pergi ke tab Komunitas, pilih sub-tab Grup, lalu klik tombol Buat Grup Baru di bawah.'),
            const SizedBox(height: 12),
            _buildFAQItem('Apa itu Mode Ruang Aman?', 'Mode Ruang Aman adalah fitur perlindungan perangkat keras (Aksesibilitas) yang akan otomatis memblokir Anda jika mencoba membuka situs/aplikasi judi online.'),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(LucideIcons.mail, size: 18),
              label: const Text('Hubungi Dukungan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D6EFD),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ExpansionTile(
        title: Text(question, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              answer,
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade600, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

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
          'Keamanan',
          style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(LucideIcons.shieldCheck, size: 80, color: Colors.teal),
            const SizedBox(height: 16),
            Text(
              'Kelola keamanan akun Anda',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: Colors.grey.shade600, fontSize: 14),
            ),
            const SizedBox(height: 32),
            _buildSecurityItem(context, 'Ubah Kata Sandi', Icons.lock_outline),
            const SizedBox(height: 12),
            _buildSecurityItem(context, 'Autentikasi 2 Faktor', Icons.security),
            const SizedBox(height: 12),
            _buildSecurityItem(context, 'Perangkat Tersambung', Icons.devices),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityItem(BuildContext context, String title, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.teal.shade50, shape: BoxShape.circle),
          child: Icon(icon, color: Colors.teal, size: 20),
        ),
        title: Text(title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$title akan segera hadir')));
        },
      ),
    );
  }
}

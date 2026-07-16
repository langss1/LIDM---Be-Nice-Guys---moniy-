import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CertificateScreen extends StatelessWidget {
  const CertificateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final pad = sw * 0.05;

    final badges = [
      {'title': 'Pemula', 'icon': LucideIcons.medal, 'color': Colors.blue},
      {'title': 'Konsisten 7 Hari', 'icon': LucideIcons.flame, 'color': Colors.orange},
      {'title': 'Pakar Modul 1', 'icon': LucideIcons.award, 'color': Colors.purple},
      {'title': 'Hemat 100K', 'icon': LucideIcons.piggyBank, 'color': Colors.green},
      {'title': 'Master Keuangan', 'icon': LucideIcons.crown, 'color': Colors.amber, 'locked': true},
      {'title': 'Investor Muda', 'icon': LucideIcons.trendingUp, 'color': Colors.teal, 'locked': true},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // ── App Bar ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sw * 0.02, vertical: sh * 0.01),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(LucideIcons.arrowLeft, color: Color(0xFF0F172A), size: 28),
                    onPressed: () => context.pop(),
                  ),
                  Expanded(
                    child: Text(
                      'Sertifikasi & Badge',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF0F172A),
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Spacer
                ],
              ),
            ),
            
            // ── Content ──
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(pad),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Koleksi Badgemu',
                      style: GoogleFonts.poppins(
                        fontSize: sw * 0.05,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    SizedBox(height: sh * 0.01),
                    Text(
                      'Selesaikan lebih banyak modul dan pertahankan streak untuk mengumpulkan badge eksklusif.',
                      style: GoogleFonts.poppins(
                        fontSize: sw * 0.035,
                        color: const Color(0xFF64748B),
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: sh * 0.04),
                    
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: pad,
                        mainAxisSpacing: pad,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: badges.length,
                      itemBuilder: (context, index) {
                        final badge = badges[index];
                        final isLocked = badge['locked'] == true;
                        
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey.shade200),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(sw * 0.04),
                                decoration: BoxDecoration(
                                  color: isLocked ? Colors.grey.shade100 : (badge['color'] as Color).withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isLocked ? LucideIcons.lock : (badge['icon'] as IconData),
                                  color: isLocked ? Colors.grey.shade400 : badge['color'] as Color,
                                  size: sw * 0.1,
                                ),
                              ),
                              SizedBox(height: sh * 0.02),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: sw * 0.02),
                                child: Text(
                                  badge['title'] as String,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: sw * 0.032,
                                    fontWeight: FontWeight.w600,
                                    color: isLocked ? Colors.grey.shade500 : const Color(0xFF0F172A),
                                  ),
                                ),
                              ),
                              if (isLocked)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    'Terkunci',
                                    style: GoogleFonts.poppins(
                                      fontSize: sw * 0.025,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ).animate(delay: (index * 100).ms).scale(duration: 400.ms, curve: Curves.easeOutBack).fadeIn();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

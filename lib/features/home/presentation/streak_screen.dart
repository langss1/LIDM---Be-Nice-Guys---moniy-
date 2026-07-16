import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class StreakScreen extends StatelessWidget {
  const StreakScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final pad = sw * 0.05;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF8CD4FF), Color(0xFFF0F6FF)], // Cerah dan ceria
            stops: [0.0, 0.4],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── App Bar Transparan ──
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
                        'Pencapaianmu',
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

              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(pad),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // ── Bagian Header dengan Monkey Asset ──
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: sh * 0.06),
                            padding: EdgeInsets.fromLTRB(pad, pad * 2.5, pad, pad * 1.5),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withValues(alpha: 0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Text(
                                  '6 Hari Beruntun!',
                                  style: GoogleFonts.poppins(
                                    fontSize: sw * 0.065,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF2E6FF2),
                                  ),
                                ),
                                SizedBox(height: sh * 0.01),
                                Text(
                                  'Hebat Mozart! Kamu terus belajar tanpa henti. Pertahankan apimu tetap menyala!',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: sw * 0.035,
                                    color: const Color(0xFF64748B),
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Monkey Asset menyembul dari atas kotak
                          Positioned(
                            top: -sh * 0.02,
                            child: Image.asset(
                              'assets/icon/icon1.png',
                              height: sh * 0.14,
                            )
                                .animate(onPlay: (c) => c.repeat(reverse: true))
                                .slideY(begin: -0.05, end: 0.05, duration: 1200.ms, curve: Curves.easeInOut),
                          ),
                        ],
                      ).animate().fade(duration: 500.ms).slideY(begin: 0.1, end: 0),
                      
                      SizedBox(height: sh * 0.04),

                      // ── Lingkaran Api Besar (Redesigned & Resized) ──
                      Container(
                        padding: EdgeInsets.symmetric(vertical: sh * 0.02, horizontal: pad),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFA726), Color(0xFFFF7043)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withValues(alpha: 0.4),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(sw * 0.035),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.25),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.local_fire_department,
                                color: Colors.white,
                                size: sw * 0.12,
                              )
                                  .animate(onPlay: (c) => c.repeat(reverse: true))
                                  .scaleXY(begin: 0.95, end: 1.05, duration: 800.ms, curve: Curves.easeInOut)
                                  .shimmer(color: Colors.white54, duration: 1500.ms),
                            ),
                            SizedBox(width: pad),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Target Harian Tercapai!',
                                    style: GoogleFonts.poppins(
                                      fontSize: sw * 0.038,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Pertahankan semangatmu besok!',
                                    style: GoogleFonts.poppins(
                                      fontSize: sw * 0.03,
                                      color: Colors.white.withValues(alpha: 0.95),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ).animate(delay: 200.ms).scale(duration: 500.ms, curve: Curves.easeOutBack),

                      SizedBox(height: sh * 0.05),

                      // ── Kartu Hari Streak ──
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: pad * 0.5, vertical: pad * 1.2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withValues(alpha: 0.06),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: pad * 0.5, bottom: pad),
                              child: Text(
                                'Minggu Ini',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _streakDay('Sen', true, sw, 0),
                                _streakDay('Sel', true, sw, 1),
                                _streakDay('Rab', true, sw, 2),
                                _streakDay('Kam', true, sw, 3),
                                _streakDay('Jum', true, sw, 4),
                                _streakDay('Sab', true, sw, 5),
                                _streakDay('Min', false, sw, 6),
                              ],
                            ),
                          ],
                        ),
                      ).animate(delay: 400.ms).fade(duration: 500.ms).slideY(begin: 0.1, end: 0),
                      
                      SizedBox(height: sh * 0.05), // Jarak bawah
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _streakDay(String day, bool done, double sw, int index) {
    return Column(
      children: [
        Container(
          width: sw * 0.115,
          height: sw * 0.20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: done 
                ? const LinearGradient(
                    colors: [Color(0xFFFFB74D), Color(0xFFFF7043)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
                : null,
            color: done ? null : const Color(0xFFF1F5F9),
            boxShadow: done 
                ? [
                    BoxShadow(
                      color: Colors.orange.withValues(alpha: 0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                day,
                style: GoogleFonts.poppins(
                  fontSize: sw * 0.03,
                  fontWeight: done ? FontWeight.w700 : FontWeight.w600,
                  color: done ? Colors.white : const Color(0xFF94A3B8),
                ),
              ),
              SizedBox(height: sw * 0.02),
              if (done)
                Icon(Icons.local_fire_department, color: Colors.white, size: sw * 0.055)
                    .animate(delay: (300 + index * 100).ms)
                    .scale(duration: 400.ms, curve: Curves.easeOutBack)
                    .fadeIn()
              else
                Container(
                  width: sw * 0.03,
                  height: sw * 0.03,
                  decoration: const BoxDecoration(
                    color: Color(0xFFCBD5E1),
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

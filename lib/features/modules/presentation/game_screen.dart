import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Color(0xFF0F172A)),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Game Bisnis Top-Up',
          style: GoogleFonts.poppins(
            color: const Color(0xFF0F172A),
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.gamepad2, size: sw * 0.3, color: const Color(0xFF2E6FF2))
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .slideY(begin: -0.1, end: 0.1, duration: 1.seconds, curve: Curves.easeInOut),
            SizedBox(height: sw * 0.06),
            Text(
              'Tantangan Dimulai!',
              style: GoogleFonts.poppins(
                fontSize: sw * 0.05,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
              ),
            ),
            SizedBox(height: sw * 0.03),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sw * 0.1),
              child: Text(
                'Selamat datang di game simulasi bisnis top-up. Segera susun strategi terbaikmu untuk mendapatkan cuan maksimal!',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: sw * 0.035,
                  color: const Color(0xFF64748B),
                  height: 1.5,
                ),
              ),
            ),
            SizedBox(height: sw * 0.1),
            ElevatedButton(
              onPressed: () {
                // Game action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E6FF2),
                padding: EdgeInsets.symmetric(horizontal: sw * 0.1, vertical: sw * 0.035),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                'Mulai Bermain',
                style: GoogleFonts.poppins(
                  fontSize: sw * 0.04,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ).animate().fade(duration: 400.ms).scale(begin: const Offset(0.9, 0.9)),
      ),
    );
  }
}

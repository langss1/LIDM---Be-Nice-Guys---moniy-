import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/repositories/user_repository.dart';

class ProgressScreen extends ConsumerStatefulWidget {
  const ProgressScreen({super.key});

  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen> {
  @override
  Widget build(BuildContext context) {
    final mq  = MediaQuery.of(context);
    final sw  = mq.size.width;
    final sh  = mq.size.height;
    final pad = sw * 0.044;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F6FF),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            // ══════════════════════════════════════════════════
            // HEADER — Progress.png + teks overlay
            // ══════════════════════════════════════════════════
            // Background gambar (full width, naturalAR)
            Stack(
              children: [
                Image.asset(
                  'assets/icon/Progress.png',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  alignment: Alignment.bottomCenter,
                ),
                Positioned(
                  left: 24,
                  top: 65,
                  child: ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Colors.black, Color(0xFF1E3A8A)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ).createShader(bounds),
                    child: Text(
                      'Pantau Progress\nMu Disini',
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ],
            ),

            // Subtitle strip
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: sh * 0.012, horizontal: pad),
              child: Text(
                'Lihat semua progres perkembangan kamu di sini',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: const Color(0xFF94A3B8),
                  fontSize: sw * 0.032,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // ══════════════════════════════════════════════════
            // BODY — Stat cards, insight, streak
            // ══════════════════════════════════════════════════
            FutureBuilder<Map<String, dynamic>>(
              future: ref.read(userRepositoryProvider).getUserStats(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                
                final data = snapshot.data ?? {};
                final profile = data['profile'] ?? {};
                final badges = (data['badges'] as List?) ?? [];
                
                final totalStreak = profile['total_streak'] ?? 0;
                final xp = profile['xp'] ?? 0;
                final name = profile['nickname'] ?? profile['name'] ?? 'Pejuang Cuan';
                final completedModules = (data['progress'] as List?)?.length ?? 0;
                final totalModules = data['total_modules'] ?? 5;
                final progressPercent = totalModules > 0 ? (completedModules / totalModules) * 100 : 0.0;
                // Dummy hour calculation based on xp for now
                final hoursPlayed = (xp / 10).floor();

                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(pad),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [

                  // ── Stat cards ─────────────────────────────
                  Row(
                    children: [
                      // Waktu Bermain
                      Expanded(
                        child: _statCard(
                          topContent: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '$hoursPlayed',
                                style: GoogleFonts.poppins(
                                  fontSize: sw * 0.09,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF3D2A06),
                                ),
                              ),
                            ],
                          ),
                          label: 'Jam Bermain',
                          bgColor: const Color(0xFFFFF3E0),
                          labelColor: Colors.orange,
                          sw: sw,
                          sh: sh,
                        ),
                      ),
                      SizedBox(width: pad),
                      // Modul Selesai
                      Expanded(
                        child: _statCard(
                          topContent: Center(
                            child: Text(
                              '$completedModules',
                              style: GoogleFonts.poppins(
                                fontSize: sw * 0.08,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF0F3B8C),
                              ),
                            ),
                          ),
                          label: 'Modul Selesai',
                          bgColor: const Color(0xFFEFF6FF),
                          labelColor: const Color(0xFF2E6FF2),
                          sw: sw,
                          sh: sh,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: pad),
                  
                  // ── Section Sertifikasi (Badge) ─────────────────────────
                  GestureDetector(
                    onTap: () => context.push('/certificate'),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: pad, vertical: pad * 0.8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF3E5F5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(LucideIcons.award, color: Color(0xFF8E24AA), size: 28),
                          ),
                          SizedBox(width: pad),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Sertifikasi Keuangan',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF0F172A),
                                    fontSize: sw * 0.038,
                                  ),
                                ),
                                Text(
                                  '${badges.length} Badge Koleksi Spesial',
                                  style: GoogleFonts.poppins(
                                    fontSize: sw * 0.032,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(LucideIcons.chevronRight, size: 20, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: pad),

                  // ── Progress Bar ───────────────────────────
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: pad, vertical: pad * 0.8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Progress Pembelajaran',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF0F172A),
                                fontSize: sw * 0.038,
                              ),
                            ),
                            Text(
                              '${progressPercent.toInt()}%',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF2E6FF2),
                                fontSize: sw * 0.038,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: pad * 0.5),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: progressPercent / 100,
                            minHeight: 12,
                            backgroundColor: Colors.blue.shade50,
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2E6FF2)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: pad),

                  // ── Insight card ───────────────────────────
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFBFD7FF)),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(pad, pad * 0.8, pad * 0.4, pad * 0.8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: sw * 0.18, // Match the height of the image to keep layout stable while allowing scrolling
                                  child: SingleChildScrollView(
                                    child: TweenAnimationBuilder<int>(
                                      tween: IntTween(begin: 0, end: 170),
                                      duration: const Duration(milliseconds: 3500),
                                      builder: (context, value, child) {
                                        final fullText = 'Keren banget kamu $name! Kamu sudah menyelesaikan $completedModules modul dan mengumpulkan $xp XP berharga. Terus pertahankan semangat belajarmu yang luar biasa ini ya!';
                                        final visibleText = fullText.substring(0, value.clamp(0, fullText.length));
                                        return Text(
                                          visibleText,
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black87,
                                            fontSize: sw * 0.036,
                                            height: 1.5,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: pad * 0.5),
                              Image.asset('assets/icon/icon2.png',
                                  height: sw * 0.18, fit: BoxFit.contain),
                            ],
                          ),
                        ),
                        // Insight button
                        Container(
                          width: double.infinity,
                          color: const Color(0xFF4D9DE0),
                          padding: EdgeInsets.symmetric(vertical: sh * 0.012),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Insight by AI ',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: sw * 0.034,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Icon(LucideIcons.sparkles,
                                  color: Colors.white, size: 14),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: pad),
                ],
              ),
            ),

            // ══════════════════════════════════════════════════
            // STREAK SECTION — background biru muda
            // ══════════════════════════════════════════════════
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFD4EDFF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              padding: EdgeInsets.all(pad),
              child: Column(
                children: [

                  // Streak Mingguan card
                  GestureDetector(
                    onTap: () => context.push('/streak'),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(pad),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Streak Mingguan',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF2E6FF2),
                                  fontSize: sw * 0.042,
                                ),
                              ),
                              const Icon(LucideIcons.chevronRight, size: 20, color: Color(0xFF2E6FF2)),
                            ],
                          ),
                          SizedBox(height: pad * 0.9),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _streakDay('Sen', true, sw),
                              _streakDay('Sel', true, sw),
                              _streakDay('Rab', true, sw),
                              _streakDay('Kam', true, sw),
                              _streakDay('Jum', true, sw),
                              _streakDay('Sab', true, sw),
                              _streakDay('Min', false, sw),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: pad),

                  // Total Streak card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                        horizontal: pad, vertical: pad * 0.85),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Streak',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF2E6FF2),
                            fontSize: sw * 0.042,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(LucideIcons.flame,
                                color: Colors.orange, size: sw * 0.055),
                            SizedBox(width: sw * 0.02),
                            Text(
                              '$totalStreak',
                              style: GoogleFonts.poppins(
                                fontSize: sw * 0.065,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF3D2A06),
                              ),
                            ),
                            SizedBox(width: sw * 0.02),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                'Hari',
                                style: GoogleFonts.poppins(
                                    color: Colors.grey,
                                    fontSize: sw * 0.032),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: pad * 0.5),
                ],
              ),
            ),
            const SizedBox(height: 100), // Padding ekstra untuk navbar
                  ],
                );
    },
  ),
  ].animate(interval: 80.ms).fade(duration: 400.ms, curve: Curves.easeOutQuart).slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuart),
  ),
  ),
  );
}

  // ── Stat card builder ─────────────────────────────────────────────────────
  Widget _statCard({
    required Widget topContent,
    required String label,
    required Color bgColor,
    required Color labelColor,
    required double sw,
    required double sh,
  }) {
    return Container(
      height: sh * 0.13,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: labelColor.withValues(alpha: 0.25)),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          Expanded(child: topContent),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: sh * 0.009),
            color: labelColor,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: sw * 0.03,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Streak day widget ─────────────────────────────────────────────────────
  Widget _streakDay(String day, bool done, double sw) => Column(
        children: [
          Container(
            width: sw * 0.1,
            height: sw * 0.1,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: done ? Colors.orange.shade50 : Colors.grey.shade100,
            ),
            child: Center(
              child: done
                  ? Icon(Icons.local_fire_department, color: Colors.orange, size: sw * 0.06)
                      .animate(onPlay: (controller) => controller.repeat(reverse: true))
                      .scaleXY(begin: 1.0, end: 1.2, duration: 600.ms, curve: Curves.easeInOut)
                      .shimmer(color: Colors.yellow, duration: 1200.ms)
                  : Container(
                      width: sw * 0.032,
                      height: sw * 0.032,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          shape: BoxShape.circle)),
            ),
          ),
          SizedBox(height: sw * 0.012),
          Text(day,
              style: GoogleFonts.poppins(
                  fontSize: sw * 0.03,
                  color: const Color(0xFF64748B))),
        ],
      );
}

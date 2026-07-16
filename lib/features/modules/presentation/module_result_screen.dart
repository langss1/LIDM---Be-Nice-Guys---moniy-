import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/repositories/game_repository.dart';

class ModuleResultScreen extends ConsumerWidget {
  const ModuleResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(currentGameScenarioProvider);
    final scenario = gameState.scenario;
    final isCorrect = gameState.isCorrect ?? false;
    final score = isCorrect ? 100 : 50;

    final resultTitle = isCorrect
        ? (scenario?['result_title'] ?? 'Keputusan Tepat!')
        : 'Perlu Belajar Lagi';

    final resultDescription = isCorrect
        ? (scenario?['result_description'] ?? 'Kamu membuat keputusan yang tepat!')
        : (scenario?['warning_text'] ??
            'Keputusanmu kurang tepat. Baca kembali ceritanya dan perhatikan tips keuangan yang benar.');

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            // Navbar Atas
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTopButton(
                    icon: Icons.arrow_back_ios_new,
                    iconColor: Colors.orange,
                    onTap: () => context.pop(),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isCorrect ? Colors.green.shade50 : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isCorrect ? '✅ Jawaban Benar!' : '❌ Kurang Tepat',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isCorrect ? Colors.green.shade700 : Colors.red.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Icon Hasil
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCorrect ? Colors.green.shade100 : Colors.orange.shade200,
                border: Border.all(
                  color: isCorrect ? Colors.green.shade300 : Colors.orange.shade300,
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isCorrect ? Colors.green : Colors.orange).withValues(alpha: 0.3),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  isCorrect ? '🎉' : '💡',
                  style: const TextStyle(fontSize: 60),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // XP Dapet
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isCorrect ? Colors.green.shade50 : Colors.blue.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('⚡', style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 6),
                  Text(
                    '+$score XP',
                    style: GoogleFonts.poppins(
                      color: isCorrect ? Colors.green.shade700 : Colors.blue.shade700,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Box Hasil
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isCorrect ? Colors.green.shade200 : Colors.orange.shade200,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      child: Text(
                        resultTitle,
                        style: GoogleFonts.poppins(
                          color: isCorrect ? Colors.green.shade700 : const Color(0xFFD97706),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Divider(
                        height: 1,
                        color: isCorrect ? Colors.green.shade100 : Colors.orange.shade100),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        resultDescription,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF334155),
                          fontSize: 13,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Tombol
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  if (!isCorrect)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: OutlinedButton(
                        onPressed: () => context.go('/module_story'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.orange,
                          side: const BorderSide(color: Colors.orange),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Coba Lagi',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(currentGameScenarioProvider.notifier).reset();
                      context.go('/modules');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isCorrect ? Colors.green.shade500 : const Color(0xFFF59E0B),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      minimumSize: const Size(double.infinity, 54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Kembali ke Modul',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopButton(
      {required IconData icon, required Color iconColor, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
    );
  }
}

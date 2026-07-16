import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/repositories/game_repository.dart';
import '../../../shared/repositories/module_repository.dart';
import '../../../shared/repositories/user_repository.dart';

class ModuleDecisionScreen extends ConsumerStatefulWidget {
  const ModuleDecisionScreen({super.key});

  @override
  ConsumerState<ModuleDecisionScreen> createState() => _ModuleDecisionScreenState();
}

class _ModuleDecisionScreenState extends ConsumerState<ModuleDecisionScreen> {
  bool _isSaving = false;

  Future<void> _selectOption(int index) async {
    if (_isSaving) return;
    
    // Update state with selected option
    ref.read(currentGameScenarioProvider.notifier).selectOption(index);
    
    setState(() => _isSaving = true);
    
    try {
      final gameState = ref.read(currentGameScenarioProvider);
      final isCorrect = index == (gameState.scenario?['correct_option'] as int? ?? 0);
      final score = isCorrect ? 100 : 50;
      
      // Save progress to database
      final profile = await ref.read(userRepositoryProvider).getCurrentUserProfile();
      if (profile != null && gameState.moduleId != 0) {
        await ref.read(moduleRepositoryProvider).saveModuleProgress(
          userId: profile['id'],
          moduleId: gameState.moduleId,
          score: score,
          progress: 1.0,
          completed: true,
        );
      }
    } catch (e) {
      // Continue even if saving fails - still show result
      debugPrint('Error saving progress: $e');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
    
    if (mounted) context.go('/module_result');
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(currentGameScenarioProvider);
    final scenario = gameState.scenario;
    final balance = scenario?['balance'] ?? 'Rp 0';
    final decisionText = scenario?['decision_text'] ?? 'Keputusan tidak ditemukan.';
    final options = List<String>.from(scenario?['options'] ?? ['Pilihan 1', 'Pilihan 2']);

    return Scaffold(
      body: Stack(
        children: [
          // Background Image Full Screen
          Positioned.fill(
            child: Image.asset(
              'assets/icon/bg.png',
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
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
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Ambil Keputusan',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.orange.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Box Saldo
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: RichText(
                        text: TextSpan(
                          text: 'Saldo kamu:  ',
                          style: GoogleFonts.poppins(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                          children: [
                            TextSpan(
                              text: balance,
                              style: GoogleFonts.poppins(
                                color: const Color(0xFFD97706),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Box Keputusan
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.orange.shade50, Colors.white],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                            ),
                            child: RichText(
                              text: TextSpan(
                                text: 'Keputusan ',
                                style: GoogleFonts.poppins(
                                  color: const Color(0xFF1E293B),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Kamu',
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xFF0D6EFD),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(height: 1, color: Colors.grey.shade100),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              decisionText,
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF334155),
                                fontSize: 14,
                                height: 1.6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Pilihan Keputusan
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  child: Column(
                    children: [
                      if (_isSaving)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: LinearProgressIndicator(),
                        ),
                      if (options.isNotEmpty)
                        _buildDecisionOption(
                          context,
                          text: options[0],
                          index: 0,
                          label: 'A',
                        ),
                      const SizedBox(height: 12),
                      if (options.length > 1)
                        _buildDecisionOption(
                          context,
                          text: options[1],
                          index: 1,
                          label: 'B',
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
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
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
    );
  }

  Widget _buildDecisionOption(BuildContext context,
      {required String text, required int index, required String label}) {
    return GestureDetector(
      onTap: _isSaving ? null : () => _selectOption(index),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.orange.shade300, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 5,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.orange.shade400,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  label,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.poppins(
                  color: const Color(0xFF334155),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

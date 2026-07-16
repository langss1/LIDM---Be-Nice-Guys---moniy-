import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/repositories/game_repository.dart';
import '../../../shared/repositories/module_repository.dart';
import '../../../shared/repositories/user_repository.dart';

class ModuleStoryScreen extends ConsumerStatefulWidget {
  final int moduleId;
  const ModuleStoryScreen({super.key, required this.moduleId});

  @override
  ConsumerState<ModuleStoryScreen> createState() => _ModuleStoryScreenState();
}

class _ModuleStoryScreenState extends ConsumerState<ModuleStoryScreen> {
  bool isLoading = true;
  String storyText = '';
  String moduleTitle = '';

  @override
  void initState() {
    super.initState();
    _loadScenario();
  }

  Future<void> _loadScenario() async {
    final scenario =
        await ref.read(gameRepositoryProvider).getGameScenarioByModuleId(widget.moduleId);
    if (mounted) {
      ref.read(currentGameScenarioProvider.notifier).updateScenario(scenario, widget.moduleId);
      setState(() {
        storyText = scenario?['story_text'] ?? 'Cerita tidak ditemukan.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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
                          'Cerita Awal',
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

                // Box Story
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                                colors: [Colors.blue.shade50, Colors.white],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                            ),
                            child: RichText(
                              text: TextSpan(
                                text: 'Panduan ',
                                style: GoogleFonts.poppins(
                                  color: const Color(0xFF1E293B),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Awal',
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
                              storyText,
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF334155),
                                fontSize: 14,
                                height: 1.7,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Tombol Navigasi
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => context.pop(),
                          icon: const Icon(Icons.arrow_back, size: 16),
                          label: const Text('Kembali'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF3B82F6),
                            side: const BorderSide(color: Color(0xFF3B82F6)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            textStyle: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () => context.go('/module_decision'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFBBF24),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            textStyle: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text('Ambil Keputusan'),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, size: 16),
                            ],
                          ),
                        ),
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
}

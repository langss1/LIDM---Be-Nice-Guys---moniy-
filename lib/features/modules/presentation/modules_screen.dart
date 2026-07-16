import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/repositories/module_repository.dart';
import '../../../shared/repositories/user_repository.dart';

class ModulesScreen extends ConsumerStatefulWidget {
  const ModulesScreen({super.key});

  @override
  ConsumerState<ModulesScreen> createState() => _ModulesScreenState();
}

class _ModulesScreenState extends ConsumerState<ModulesScreen> {
  List<Map<String, dynamic>> _modules = [];
  bool _isLoading = true;
  int? _userId;

  @override
  void initState() {
    super.initState();
    _loadModules();
  }

  Future<void> _loadModules() async {
    try {
      final profile = await ref.read(userRepositoryProvider).getCurrentUserProfile();
      _userId = profile?['id'];

      if (_userId != null) {
        final modules =
            await ref.read(moduleRepositoryProvider).getModulesWithProgress(_userId!);
        if (mounted) setState(() => _modules = modules);
      } else {
        final modules = await ref.read(moduleRepositoryProvider).getModules();
        if (mounted) {
          setState(() => _modules = modules.map((m) => {...m, 'completed': false, 'score': 0}).toList());
        }
      }
    } catch (e) {
      debugPrint('Error loading modules: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _loadModules,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Header ──────────────────────────────
              Stack(
                children: [
                  Image.asset(
                    'assets/icon/modul.png',
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
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Jelajahi Dunia Keuangan\n',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                height: 1.2,
                              ),
                            ),
                            TextSpan(
                              text: 'Dengan Interaktif',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_modules.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(child: Text('Tidak ada modul tersedia.')),
                )
              else
                _buildModuleContent(sw),

              const SizedBox(height: 32),

              // ── Banner Promosi ───────────────────────
              Image.asset(
                'assets/icon/promosi.png',
                width: double.infinity,
                fit: BoxFit.fitWidth,
              ),

              const SizedBox(height: 110),
            ].animate(interval: 80.ms).fade(duration: 400.ms, curve: Curves.easeOutQuart).slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuart),
          ),
        ),
      ),
    );
  }

  Widget _buildModuleContent(double sw) {
    final completedModules = _modules.where((m) => m['completed'] == true).toList();
    final pendingModules = _modules.where((m) => m['completed'] != true).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Stats Row ───────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              _statChip('📚', '${_modules.length}', 'Total Modul'),
              const SizedBox(width: 12),
              _statChip('✅', '${completedModules.length}', 'Selesai'),
              const SizedBox(width: 12),
              _statChip('⚡', '${completedModules.fold(0, (sum, m) => sum + (m['score'] as int? ?? 0))}', 'XP'),
            ],
          ),
        ),
        const SizedBox(height: 20),

        if (pendingModules.isNotEmpty) ...[
          // ── Title "Modul Tersedia" ──────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Modul Tersedia',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                GestureDetector(
                  onTap: () => context.push('/module_list'),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      LucideIcons.list,
                      color: Color(0xFF2E6FF2),
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Horizontal Scroll
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: pendingModules.map((mod) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: _moduleCard(
                    context: context,
                    title: mod['title'] ?? 'Untitled',
                    isNew: mod['is_new'] ?? false,
                    genre: mod['genre'] ?? '',
                    sw: sw,
                    moduleId: mod['id'] ?? 1,
                    completed: false,
                    score: 0,
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),
        ],

        if (completedModules.isNotEmpty) ...[
          // ── Title "Sudah Selesai" ────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Sudah Diselesaikan ✅',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E293B),
              ),
            ),
          ),
          const SizedBox(height: 16),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: completedModules.map((mod) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: _moduleCard(
                    context: context,
                    title: mod['title'] ?? 'Untitled',
                    isNew: mod['is_new'] ?? false,
                    genre: mod['genre'] ?? '',
                    sw: sw,
                    moduleId: mod['id'] ?? 1,
                    completed: true,
                    score: mod['score'] ?? 0,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }

  Widget _statChip(String emoji, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E293B),
              ),
            ),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 10,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _moduleCard({
    required BuildContext context,
    required String title,
    required bool isNew,
    required String genre,
    required double sw,
    required int moduleId,
    required bool completed,
    required int score,
  }) {
    return GestureDetector(
      onTap: () => context.push('/module_story', extra: moduleId),
      child: Container(
        width: sw * 0.45,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: completed ? Colors.green.shade300 : const Color(0xFFE2E8F0),
            width: completed ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Thumbnail
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  child: Image.asset(
                    'assets/icon/Content.png',
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 100,
                      color: Colors.blue.shade50,
                      child: const Icon(Icons.book, color: Colors.blue, size: 40),
                    ),
                  ),
                ),
                // Badge
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: completed ? Colors.green.shade400 : (isNew ? const Color(0xFFFBBF24) : Colors.blue.shade400),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(8),
                      ),
                    ),
                    child: Text(
                      completed ? '✅ Selesai' : (isNew ? '✨ Baru' : genre),
                      style: GoogleFonts.poppins(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Konten
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 38,
                    child: Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1E293B),
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (completed) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text('⚡', style: const TextStyle(fontSize: 12)),
                        const SizedBox(width: 4),
                        Text(
                          '$score XP',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.green.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 8),
                  // Tombol
                  SizedBox(
                    width: double.infinity,
                    height: 32,
                    child: completed
                        ? OutlinedButton(
                            onPressed: () => context.push('/module_story', extra: moduleId),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              side: BorderSide(color: Colors.green.shade400),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              'Ulangi',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.green.shade600,
                              ),
                            ),
                          )
                        : ElevatedButton(
                            onPressed: () => context.push('/module_story', extra: moduleId),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              backgroundColor: const Color(0xFF0D6EFD),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              'Mulai',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

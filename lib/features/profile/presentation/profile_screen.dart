import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/repositories/user_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool isProteksiNyala = false;

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<Map<String, dynamic>>(
        future: ref.read(userRepositoryProvider).getUserStats(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data ?? {};
          final profile = data['profile'] ?? {};
          final badges = (data['badges'] as List?) ?? [];
          
          final supabaseUser = Supabase.instance.client.auth.currentUser;
          final fullName = profile['name'] ?? supabaseUser?.userMetadata?['name'] ?? 'User';
          final firstName = fullName.split(' ').first;
          final lastName = fullName.replaceFirst(firstName, '').trim();
          final phone = profile['phone'] ?? supabaseUser?.userMetadata?['phone'] ?? '-';
          final level = profile['level'] ?? 1;
          final xp = profile['xp'] ?? 0;
          final xpForNextLevel = level * 100;
          final remainingXp = xpForNextLevel - xp;
          final progressPercent = (xp / xpForNextLevel * 100).clamp(0, 100).toInt();

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                // ── HEADER (Background, Avatar, Card Info) ──────────
                SizedBox(
                  height: 270, 
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                  // Gambar Background Atas
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 190,
                    child: Image.asset(
                      'assets/icon/bg.png',
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      errorBuilder: (context, error, stackTrace) => 
                        Container(color: Colors.blue.shade50),
                    ),
                  ),

                  // Tombol Logout di kanan atas
                  Positioned(
                    top: 60,
                    right: 20,
                    child: GestureDetector(
                      onTap: () async {
                        await Supabase.instance.client.auth.signOut();
                        if (context.mounted) context.go('/login');
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.25),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.logout_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ),

                  // Card Informasi User (Melayang di bawah)
                  Positioned(
                    bottom: 0,
                    left: 12,
                    right: 12,
                    child: Container(
                      height: 130,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Baris Nama & Badge
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: '$firstName ',
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFF1E293B),
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: lastName,
                                      style: GoogleFonts.poppins(
                                        color: const Color(0xFF2563EB), // Biru khas
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          
                          // Baris Nomor Telepon (Background Biru Muda)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: const BoxDecoration(
                              color: Color(0xFFE5F0FF), // Biru terang pucat (sesuai referensi)
                              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              phone,
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF64748B),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Foto Profil (Berada di atas batas Card putih)
                  Positioned(
                    bottom: 84, // Melayang persis di border atas card (karena card height 130, radius 42+4=46)
                    child: Container(
                      padding: const EdgeInsets.all(4), // Border putih
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const CircleAvatar(
                        radius: 42,
                        backgroundColor: Color(0xFFE2E8F0),
                        backgroundImage: AssetImage('assets/icon/Logo.png'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── KONTEN PROFIL ──────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Title Pencapaian Pribadi
                  Text(
                    'Pencapaian Pribadi',
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  SizedBox(
                    height: 120, // Tinggi lebih lega
                    child: badges.isEmpty
                        ? Center(
                            child: Text(
                              'Belum ada badge yang terkumpul',
                              style: GoogleFonts.poppins(color: Colors.grey),
                            ),
                          )
                        : ListView.separated(
                            scrollDirection: Axis.horizontal,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: badges.length,
                            separatorBuilder: (context, index) => const SizedBox(width: 14),
                            itemBuilder: (context, index) {
                              final badge = badges[index]['badges'];
                              return _buildAchievementCard(badge?['name'] ?? 'Badge');
                            },
                          ),
                  ),
                  const SizedBox(height: 24),

                  // Card Level 3 & Progress Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFF1F5F9), width: 2), // Border abu sangat tipis
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF7ED),
                                shape: BoxShape.circle,
                                border: Border.all(color: const Color(0xFFFDE68A)),
                              ),
                              child: const Icon(Icons.stars, color: Color(0xFFF59E0B), size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  text: 'Level $level',
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFF2563EB),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '  — $remainingXp poin lagi untuk ke level ${level + 1}',
                                      style: GoogleFonts.poppins(
                                        color: const Color(0xFF64748B),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Progress Bar Custom
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 10,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: progressPercent,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF2563EB),
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: (100 - progressPercent).toInt(),
                                      child: const SizedBox(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Teks Progress (70/100)
                            SizedBox(
                              width: 50,
                              child: RichText(
                                textAlign: TextAlign.right,
                                text: TextSpan(
                                  text: '$progressPercent',
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFF2563EB),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '/100',
                                      style: GoogleFonts.poppins(
                                        color: const Color(0xFF94A3B8),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── LIHAT PROGRESS ──────────────────────────────────
                  Container(
                    width: double.infinity,
                    height: sh * 0.16,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      image: const DecorationImage(
                        image: AssetImage('assets/icon/Progress Home.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: sh * 0.02,
                          left: sw * 0.04,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ShaderMask(
                                blendMode: BlendMode.srcIn,
                                shaderCallback: (bounds) => const LinearGradient(
                                  colors: [Color(0xFF1E3A8A), Colors.black],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ).createShader(bounds),
                                child: Text(
                                  'Lihat\nProgress',
                                  style: GoogleFonts.poppins(
                                    fontSize: sw * 0.055,
                                    fontWeight: FontWeight.w800,
                                    height: 1.1,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              GestureDetector(
                                onTap: () => context.go('/progress'),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2E6FF2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'disini',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: sw * 0.025,
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
                  const SizedBox(height: 24),

                  // ── PENGATURAN AKUN ─────────────────────────────
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pengaturan Akun',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          children: [
                            _buildSettingMenu(Icons.person, 'Edit Profil', true, onTap: () {
                              context.push('/edit_profile');
                            }),
                            _buildSettingMenu(Icons.security, 'Keamanan', true, onTap: () {
                              context.push('/security');
                            }),
                            _buildSettingMenu(Icons.help_outline, 'Pusat Bantuan', false, onTap: () {
                              context.push('/help_center');
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── GAMBAR PROTEKSI (INTERAKTIF) ──────────────────────
            GestureDetector(
              onTap: () {
                setState(() {
                  isProteksiNyala = !isProteksiNyala;
                });
              },
              child: Image.asset(
                isProteksiNyala ? 'assets/icon/nyala.png' : 'assets/icon/belum.png',
                width: sw,
                fit: BoxFit.fitWidth,
                errorBuilder: (context, error, stackTrace) => const SizedBox(),
              ),
            ),

            // Extra space dihapus agar tidak overscroll,
            // (BottomNavBar sudah di-handle oleh root Scaffold)
            const SizedBox(height: 100),
          ].animate(interval: 80.ms).fade(duration: 400.ms, curve: Curves.easeOutQuart).slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuart),
        ),
      );
      },
      ),
    );
  }

  // Komponen Helper Untuk Kancil Cerdik
  Widget _buildAchievementCard(String name) {
    return Container(
      width: 95, 
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFDE68A), width: 1.5), // Kuning lembut outline
      ),
      child: Column(
        children: [
          // Ruang untuk gambar medali kancil
          Expanded(
            child: Center(
              child: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: Color(0xFFFDE68A), // Kuning emas bundar
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.pets, color: Color(0xFFD97706), size: 28),
              ),
            ),
          ),
          // Bawah warna orange penuh
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFFF59E0B), // Orange Solid (lebih tebal)
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(14)),
            ),
            alignment: Alignment.center,
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
  // Helper Statistik
  Widget _buildStatCard(String title, String value, String unit, IconData icon, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color.shade600, size: 24),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.poppins(color: color.shade700, fontSize: 12, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              text: value,
              style: GoogleFonts.poppins(color: color.shade900, fontSize: 24, fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                  text: ' $unit',
                  style: GoogleFonts.poppins(color: color.shade700, fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper Pengaturan
  Widget _buildSettingMenu(IconData icon, String title, bool hasBorder, {VoidCallback? onTap}) {
    return Container(
      decoration: BoxDecoration(
        border: hasBorder ? Border(bottom: BorderSide(color: Colors.grey.shade100)) : null,
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xFF0D6EFD), size: 20),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF1E293B)),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        onTap: onTap ?? () {},
      ),
    );
  }
}

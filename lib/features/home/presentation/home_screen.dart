import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../theme/colors.dart';
import '../../../shared/providers/supabase_provider.dart';
import '../../../shared/repositories/module_repository.dart';
import '../../../shared/repositories/user_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/services.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with WidgetsBindingObserver {
  bool isToggleActive = false;
  int totalStreak = 0;
  bool isLoading = true;
  static const platform = MethodChannel('com.example.moniy/accessibility');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPermission();
    }
  }

  Future<void> _checkPermission() async {
    try {
      final bool result = await platform.invokeMethod('isAccessibilityEnabled');
      if (mounted) {
        setState(() {
          isToggleActive = result;
        });
        
        final currentUser = Supabase.instance.client.auth.currentUser;
        if (currentUser?.email != null) {
          await Supabase.instance.client.from('users').update({'is_gambling_block': result}).eq('email', currentUser!.email!);
        }
      }
    } on PlatformException catch (_) {}
  }

  Future<void> _loadData() async {
    final profile = await ref.read(userRepositoryProvider).getCurrentUserProfile();
    if (profile != null && mounted) {
      setState(() {
        isToggleActive = profile['is_gambling_block'] ?? false;
        totalStreak = profile['total_streak'] ?? 0;
        isLoading = false;
      });
      if (isToggleActive) {
        try { platform.invokeMethod('setNativeProtection', true); } catch (_) {}
      }
    } else {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq   = MediaQuery.of(context);
    final sw   = mq.size.width;
    final sh   = mq.size.height;
    final hPad = sw * 0.044;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF6AB6E2), Colors.white], // Biru sedikit lebih gelap
            stops: [0.0, 0.38],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: hPad, vertical: hPad * 0.8),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Kartu Halo Mozart ─────────────────────────────────────
                GestureDetector(
                  onTap: () => context.go('/modules'),
                  child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.blue.withValues(alpha: 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(hPad, hPad * 0.7, hPad * 0.6, hPad * 0.7),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Halo, ',
                                    style: GoogleFonts.poppins(
                                      fontSize: sw * 0.045,
                                      fontWeight: FontWeight.w400, // Agak normal
                                      color: const Color(0xFF0F172A),
                                    ),
                                  ),
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.baseline,
                                    baseline: TextBaseline.alphabetic,
                                    child: ShaderMask(
                                      blendMode: BlendMode.srcIn,
                                      shaderCallback: (bounds) => const LinearGradient(
                                        colors: [Colors.black, Color(0xFF1E3A8A)], // Hitam lalu biru tua
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ).createShader(bounds),
                                      child: Text(
                                        ref.watch(currentUserProvider)?.userMetadata?['name'] ?? 'Guest',
                                        style: GoogleFonts.poppins(
                                          fontSize: sw * 0.045,
                                          fontWeight: FontWeight.w600, // Semi bold
                                        ),
                                      ),
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' 👋',
                                    style: TextStyle(fontSize: sw * 0.045),
                                  ),
                                ],
                              ),
                            ),
                            // Avatar biru
                            Image.asset(
                              'assets/icon/icon3.png',
                              height: sw * 0.13,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: hPad, vertical: hPad * 0.55),
                        decoration: const BoxDecoration(
                          color: Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                        ),
                        child: _TypingGreetingText(fontSize: sw * 0.034),
                      ),
                    ],
                  ),
                ),
                ),
                SizedBox(height: sh * 0.024), // Tambah space antara card

                // ── Streak Mingguan ───────────────────────────────────────
                GestureDetector(
                  onTap: () => context.push('/streak'),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: hPad, vertical: hPad * 0.95), // Tambah padding dalam
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.blue.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ShaderMask(
                            blendMode: BlendMode.srcIn,
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [Color(0xFF1E3A8A), Colors.black], // Biru tua ke hitam
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ).createShader(bounds),
                            child: Text(
                              'Streak Mingguan',
                              style: GoogleFonts.poppins(
                                fontSize: sw * 0.04,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                shape: BoxShape.circle),
                            child: Icon(LucideIcons.chevronRight,
                                size: sw * 0.038,
                                color: AppColors.primaryBlue),
                          ),
                        ],
                      ),
                      SizedBox(height: sh * 0.035),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _streakDay('Sen', totalStreak >= 1, sw, 0),
                          _streakDay('Sel', totalStreak >= 2, sw, 1),
                          _streakDay('Rab', totalStreak >= 3, sw, 2),
                          _streakDay('Kam', totalStreak >= 4, sw, 3),
                          _streakDay('Jum', totalStreak >= 5, sw, 4),
                          _streakDay('Sab', totalStreak >= 6, sw, 5),
                          _streakDay('Min', totalStreak >= 7, sw, 6),
                        ],
                      ),
                    ],
                  ),
                ),
                ),
                SizedBox(height: sh * 0.025), // Margin sebelum toggle

                // ── Toggle Aktif / Tidak Aktif ────────────────────────────
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          title: Text(
                            isToggleActive ? 'Matikan Blokir Judi?' : 'Aktifkan Blokir Judi?',
                            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          content: Text(
                            isToggleActive 
                              ? 'Apakah Anda yakin ingin mematikan fitur pemblokiran situs judi online?' 
                              : 'Fitur ini akan secara otomatis memblokir akses ke berbagai situs dan aplikasi judi online demi keamanan finansialmu. Lanjutkan?',
                            style: GoogleFonts.poppins(fontSize: 14),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Batal', style: GoogleFonts.poppins(color: Colors.grey, fontWeight: FontWeight.w600)),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2E6FF2),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () async {
                                final newValue = !isToggleActive;
                                setState(() {
                                  isToggleActive = newValue;
                                });
                                Navigator.pop(context);
                                
                                // Call Native Block Method
                                try {
                                  if (newValue) {
                                    final bool isEnabled = await platform.invokeMethod('isAccessibilityEnabled');
                                    if (!isEnabled) {
                                      await platform.invokeMethod('requestAccessibilityPermission');
                                      setState(() {
                                        isToggleActive = false;
                                      });
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Silakan aktifkan layanan aksesibilitas Moniy terlebih dahulu')));
                                      }
                                      return;
                                    }
                                  }
                                  
                                  await platform.invokeMethod('setNativeProtection', newValue);
                                  
                                  // Update Supabase Database
                                  final currentUser = Supabase.instance.client.auth.currentUser;
                                  if (currentUser?.email != null) {
                                     await Supabase.instance.client.from('users').update({'is_gambling_block': newValue}).eq('email', currentUser!.email!);
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error hardware blocker: $e')));
                                     setState(() {
                                       isToggleActive = !newValue;
                                     });
                                  }
                                }
                              },
                              child: Text('Ya', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: sw * 0.04, vertical: sh * 0.02),
                    decoration: BoxDecoration(
                      color: isToggleActive ? const Color(0xFFF8FAFC) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: isToggleActive ? const Color(0xFF2E6FF2) : Colors.grey.shade200, width: isToggleActive ? 1.5 : 1.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withValues(alpha: 0.08),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          isToggleActive ? 'assets/icon/icon1.png' : 'assets/icon/icon3.png',
                          height: sw * 0.12,
                        ),
                        SizedBox(width: sw * 0.04),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mode Blokir Judi',
                                style: GoogleFonts.poppins(
                                  fontSize: sw * 0.038,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                isToggleActive 
                                  ? 'Akses ke situs & aplikasi judi online otomatis diblokir.' 
                                  : 'Aktifkan fitur ini untuk melindungi finansialmu dari judi online.',
                                style: GoogleFonts.poppins(
                                  fontSize: sw * 0.03,
                                  color: const Color(0xFF64748B),
                                  fontWeight: FontWeight.w500,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Custom Switch
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          width: 50,
                          height: 28,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          alignment: isToggleActive ? Alignment.centerRight : Alignment.centerLeft,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: isToggleActive ? const Color(0xFF2E6FF2) : Colors.grey.shade300,
                          ),
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                )
                              ]
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: sh * 0.035), // Margin setelah toggle

                // ── Header Modul ──────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Lanjutkan Modul Terakhir',
                      style: GoogleFonts.poppins(
                        fontSize: sw * 0.04,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                      child: Text(
                        'Selengkapnya',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF2E6FF2),
                          fontWeight: FontWeight.w600,
                          fontSize: sw * 0.034,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: sh * 0.01),

                // ── Kartu Modul (horizontal, no‑scroll feel, Expanded) ────
                // ── Kartu Modul (horizontal, no‑scroll feel, Expanded) ────
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: ref.read(moduleRepositoryProvider).getModules(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError || (snapshot.data ?? []).isEmpty) {
                      return const Center(child: Text('Tidak ada modul tersedia.'));
                    }
                    final modules = snapshot.data!;
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      child: Row(
                        children: modules.map((mod) {
                           return Padding(
                             padding: EdgeInsets.only(right: sw * 0.04),
                             child: _moduleCard(context, mod['title'] ?? 'Untitled', mod['is_ai_generated'] ?? false, sw, sh, mod['id'] ?? 1),
                           );
                        }).toList(),
                      ),
                    );
                  }
                ),
                SizedBox(height: sh * 0.025), // Margin diperbesar


              ].animate(interval: 80.ms).fade(duration: 400.ms, curve: Curves.easeOutQuart).slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuart),
            ),
          ),
          ),
        ),
      ),
    );
  }

  // ── Widget hari streak ──────────────────────────────────────────────────
  Widget _streakDay(String day, bool done, double sw, int index) => Column(
        children: [
          Container(
            width: sw * 0.087,
            height: sw * 0.087,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: done ? Colors.orange.shade50 : Colors.grey.shade100,
            ),
            child: Center(
              child: done
                  ? Icon(Icons.local_fire_department_rounded,
                          color: Colors.orange, size: sw * 0.048)
                      .animate(delay: (400 + index * 100).ms)
                      .scale(duration: 400.ms, curve: Curves.easeOutBack)
                      .fadeIn()
                  : Container(
                      width: sw * 0.028,
                      height: sw * 0.028,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          shape: BoxShape.circle)),
            ),
          ),
          SizedBox(height: sw * 0.01),
          Text(day,
              style: GoogleFonts.poppins(
                  fontSize: sw * 0.028,
                  color: const Color(0xFF64748B))),
        ],
      );

  // ── Widget kartu modul ─────────────────────────────────────────────────
  Widget _moduleCard(BuildContext context, String title, bool aiGen, double sw, double sh, int moduleId) {
    final cardW = sw * 0.43;

    return Container(
      width: cardW,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Gambar
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(14)),
                child: Image.asset(
                  'assets/icon/card.png',
                  height: sh * 0.15,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              if (aiGen)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(14),
                        bottomLeft: Radius.circular(8),
                      ),
                    ),
                    child: Text('AI Generated',
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
            ],
          ),

          // Teks & tombol
          Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: sw * 0.03, vertical: sw * 0.025),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: sw * 0.09,
                    child: Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: sw * 0.032,
                        height: 1.3,
                        color: const Color(0xFF1E293B),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 32,
                    child: OutlinedButton(
                      onPressed: () => context.push('/module_story', extra: moduleId),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF2E6FF2),
                        side: const BorderSide(color: Color(0xFFBFD7FF)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        padding: EdgeInsets.zero,
                      ),
                      child: Text('Lanjutkan',
                          style: GoogleFonts.poppins(
                              fontSize: sw * 0.03,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _TypingGreetingText extends StatefulWidget {
  final double fontSize;
  const _TypingGreetingText({required this.fontSize});

  @override
  State<_TypingGreetingText> createState() => _TypingGreetingTextState();
}

class _TypingGreetingTextState extends State<_TypingGreetingText> {
  final List<String> _phrases = [
    'Sudah siap berpetualang?',
    'Sudah siap jelajahi?',
    'Sudah siap belajar?',
    'Belajar jelajahi keuangan',
  ];
  int _phraseIndex = 0;
  String _displayedText = '';
  int _charIndex = 0;
  bool _isFinished = false;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  void _startTyping() {
    if (_isFinished || !mounted) return;
    
    final targetText = _phrases[_phraseIndex];
    if (_charIndex < targetText.length) {
      Future.delayed(const Duration(milliseconds: 60), () {
        if (!mounted) return;
        setState(() {
          _charIndex++;
          _displayedText = targetText.substring(0, _charIndex);
        });
        _startTyping();
      });
    } else {
      if (_phraseIndex == _phrases.length - 1) {
        _isFinished = true;
      } else {
        Future.delayed(const Duration(seconds: 4), () {
          if (!mounted) return;
          setState(() {
            _phraseIndex++;
            _charIndex = 0;
            _displayedText = '';
          });
          _startTyping();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        _displayedText,
        style: GoogleFonts.poppins(
          color: const Color(0xFF64748B),
          fontWeight: FontWeight.w500,
          fontSize: widget.fontSize,
        ),
      ),
    );
  }
}

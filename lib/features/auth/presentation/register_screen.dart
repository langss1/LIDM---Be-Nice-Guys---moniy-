import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscureText1 = true;
  bool _obscureText2 = true;
  bool _isLoading = false;

  final _nameController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _nicknameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final pass = _passwordController.text;
    final confirm = _confirmPasswordController.text;

    if (name.isEmpty || email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Semua kolom harus diisi')));
      return;
    }
    if (pass != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password tidak cocok')));
      return;
    }
    
    setState(() => _isLoading = true);
    try {
      await Supabase.instance.client.auth.signUp(
        email: email,
        password: pass,
        data: {'name': name},
      );
      
      // Insert to public.users to create the profile
      await Supabase.instance.client.from('users').insert({
        'email': email,
        'name': name,
        'phone': '-',
        'level': 1,
        'xp': 0,
        'total_streak': 0,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registrasi berhasil! Silahkan login.')));
        context.go('/login');
      }
    } on AuthException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Register failed: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            // ══════════════════════════════════════════════════
            // HEADER — Login.png sebagai background, teks overlay
            // Height = screenWidth * 0.80 ≈ 1.45x ukuran natural
            // ══════════════════════════════════════════════════
            SizedBox(
              height: screenWidth * 0.80,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background image — cover, monyet agak ke kanan
                    Image.asset(
                      'assets/icon/Login.png',
                      fit: BoxFit.cover,
                      alignment: const Alignment(1.2, -1.0), // Geser gambar sedikit ke kanan
                    ),

                    // Badge + Teks overlay di area langit
                    Positioned(
                      top: topPad + 40, // Agak ke bawah
                      left: 20,
                      right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Badge "Moniy"
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/icon/Logo.png',
                                  width: 24,
                                  height: 24,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Moniy',
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFF2E6FF2),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 14),

                          // Teks judul
                          SizedBox(
                            width: screenWidth * 0.65,
                            child: ShaderMask(
                              blendMode: BlendMode.srcIn,
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [Colors.black, Color(0xFF2E6FF2)], // Gradien hitam ke biru
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ).createShader(bounds),
                              child: Text.rich(
                                TextSpan(
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w800, // Lebih bold
                                    fontSize: 18,
                                    height: 1.3,
                                  ),
                                  children: [
                                    const TextSpan(text: 'Belajar Jelajahi\nDunia '),
                                    TextSpan(
                                      text: 'Keuangan',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w800,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
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
            ),

            // ══════════════════════════════════════════════════
            // FORM SECTION — putih bersih
            // ══════════════════════════════════════════════════
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  // Tab Log In / Daftar
                  Container(
                    height: 48,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        // Log In (tidak aktif)
                        Expanded(
                          child: GestureDetector(
                            onTap: () => context.go('/login'),
                            child: Container(
                              color: Colors.transparent,
                              alignment: Alignment.center,
                              child: Text(
                                'Log In',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF94A3B8),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Daftar (aktif)
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(9),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Daftar',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1E293B),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Nama Lengkap & Nama Panggilan
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Nama Lengkap',
                                style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: const Color(0xFF475569),
                                    fontWeight: FontWeight.w500)),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _nameController,
                              style: GoogleFonts.poppins(fontSize: 13),
                              decoration: _inputDeco('Nama lengkap'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Nama Panggilan',
                                style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: const Color(0xFF475569),
                                    fontWeight: FontWeight.w500)),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _nicknameController,
                              style: GoogleFonts.poppins(fontSize: 13),
                              decoration: _inputDeco('Panggilan'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Email
                  Text('Email',
                      style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: const Color(0xFF475569),
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: GoogleFonts.poppins(fontSize: 14),
                    decoration: _inputDeco('email@mail.com'),
                  ),
                  const SizedBox(height: 12),

                  // Password
                  Text('Password',
                      style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: const Color(0xFF475569),
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscureText1,
                    style: GoogleFonts.poppins(fontSize: 14),
                    decoration: _inputDeco('••••••••').copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText1 ? LucideIcons.eyeOff : LucideIcons.eye,
                          color: const Color(0xFF94A3B8),
                          size: 18,
                        ),
                        onPressed: () =>
                            setState(() => _obscureText1 = !_obscureText1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Konfirmasi Password
                  Text('Konfirmasi Password',
                      style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: const Color(0xFF475569),
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureText2,
                    style: GoogleFonts.poppins(fontSize: 14),
                    decoration: _inputDeco('••••••••').copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText2 ? LucideIcons.eyeOff : LucideIcons.eye,
                          color: const Color(0xFF94A3B8),
                          size: 18,
                        ),
                        onPressed: () =>
                            setState(() => _obscureText2 = !_obscureText2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Tombol Daftar
                  ElevatedButton(
                    onPressed: _isLoading ? null : _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3D5AF1),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading 
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text(
                          'Daftar',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDeco(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(
          color: const Color(0xFFCBD5E1),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: Color(0xFF2E6FF2), width: 1.5)),
      );
}

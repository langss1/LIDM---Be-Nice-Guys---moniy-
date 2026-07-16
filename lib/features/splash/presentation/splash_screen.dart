import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:video_player/video_player.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _navigationTimer;
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    
    // Inisialisasi video player
    _controller = VideoPlayerController.asset('assets/icon/splash.mp4')
      ..initialize().then((_) {
        _controller.setVolume(0.0); // Mute video agar diizinkan autoplay oleh browser (Chrome/Web)
        _controller.play();
        _controller.setLooping(false); // Jangan di-loop agar bisa pindah halaman setelah habis
        setState(() {}); // Render ulang saat video siap

        // Berpindah ke halaman login TEPAT setelah durasi video habis
        _navigationTimer = Timer(_controller.value.duration, () {
          if (mounted) {
            context.go('/login');
          }
        });
      }).catchError((error) {
        debugPrint("Error loading splash video: $error");
        // Fallback jika video gagal dimuat
        _navigationTimer = Timer(const Duration(seconds: 3), () {
          if (mounted) context.go('/login');
        });
      });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Sesuaikan warna background Scaffold dengan background video yang abu-abu muda
      backgroundColor: const Color(0xFFF8F8F8),
      body: Center(
        child: _controller.value.isInitialized
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Video Landscape Selebar Layar (digeser ke kanan sedikit)
                  Transform.translate(
                    offset: const Offset(15, 0), // Geser video ke kanan agar wajah selaras dengan teks
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width, // Lebar penuh
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio, // Rasio asli video
                        // Potong pinggiran video (terutama garis hitam/hijau di bagian bawah)
                        child: ClipRect(
                          child: Transform.scale(
                            scale: 1.05, // Perbesar video 5%
                            child: VideoPlayer(_controller),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Jarak dekat antara video dan teks
                  const SizedBox(height: 12),

                  // Teks statis "Moniy" di bawah video
                  Text(
                    'Moniy',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF2E6FF2),
                      fontWeight: FontWeight.w700, // Bold
                      fontSize: 36,
                      letterSpacing: 1.5,
                    ),
                  )
                  .animate(delay: 300.ms)
                  .fadeIn(duration: 800.ms, curve: Curves.easeOut)
                  .scaleXY(begin: 0.5, end: 1.0, duration: 800.ms, curve: Curves.easeOutBack)
                  .moveY(begin: 20, end: 0, duration: 800.ms, curve: Curves.easeOutBack)
                  .shimmer(delay: 1100.ms, duration: 1500.ms, color: Colors.white54),
                ],
              )
            : const SizedBox.shrink(), // Kosongkan layar secara total saat loading
      ),
    );
  }
}

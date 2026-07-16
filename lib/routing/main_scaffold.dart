import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
class MainScaffold extends StatelessWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Tentukan currentIndex dari route saat ini
    final String location = GoRouterState.of(context).uri.path;
    int currentIndex = 0;
    if (location.startsWith('/chatbot')) {
      currentIndex = 1;
    } else if (location.startsWith('/modules')) {
      currentIndex = 2;
    } else if (location.startsWith('/community')) {
      currentIndex = 3;
    } else if (location.startsWith('/profile')) {
      currentIndex = 4;
    }

    // Fungsi tap
    void _onItemTapped(int index, BuildContext context) {
      if (index == currentIndex) return;
      switch (index) {
        case 0:
          context.go('/home');
          break;
        case 1:
          context.go('/chatbot');
          break;
        case 2:
          context.go('/modules');
          break;
        case 3:
          context.go('/community');
          break;
        case 4:
          context.go('/profile');
          break;
      }
    }

    // Definisi icon (Solid untuk aktif, Outline untuk tidak aktif)
    final List<Map<String, dynamic>> items = [
      {'label': 'Beranda', 'icon': Icons.home, 'icon_outline': Icons.home_outlined},
      {'label': 'Moni AI', 'icon': Icons.smart_toy, 'icon_outline': Icons.smart_toy_outlined},
      {'label': 'Modul', 'icon': Icons.library_books, 'icon_outline': Icons.library_books_outlined},
      {'label': 'Komunitas', 'icon': Icons.groups, 'icon_outline': Icons.groups_outlined},
      {'label': 'Profil', 'icon': Icons.account_circle, 'icon_outline': Icons.account_circle_outlined},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        switchInCurve: Curves.easeOutQuart,
        switchOutCurve: Curves.easeInQuart,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.96, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutQuart),
              ),
              child: child,
            ),
          );
        },
        // We use child's unique key to trigger the animation on route change
        child: KeyedSubtree(
          key: ValueKey<int>(currentIndex),
          child: child,
        ),
      ),
      // Navbar gaya iOS modern: Blur, semi-transparan, padding lega
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.only(top: 2), // Tebal garis border
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              gradient: LinearGradient(
                colors: [Color(0xFF87CEEB), Color(0xFF2563EB)], // Gradient biru cerah ke biru pekat
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Container(
              padding: const EdgeInsets.only(top: 12, bottom: 24), // Padding lega untuk safe area bawah
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.85), // Semi transparan putih (acrylic)
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SafeArea(
              top: false,
              bottom: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround, // Space around agar lega dari pinggir
                children: List.generate(items.length, (i) {
                  final isSelected = i == currentIndex;
                  final color = isSelected ? const Color(0xFF2563EB) : const Color(0xFF64748B);
                  
                  // Gunakan ikon outline jika tidak dipilih
                  IconData iconData = items[i]['icon'];
                  if (!isSelected && items[i]['icon_outline'] != null) {
                    iconData = items[i]['icon_outline'];
                  }
                  
                  return GestureDetector(
                    onTap: () => _onItemTapped(i, context),
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            iconData,
                            color: color,
                            size: 26,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            items[i]['label'],
                            style: GoogleFonts.poppins(
                              color: color,
                              fontSize: 10.5,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';

class ModuleListScreen extends StatefulWidget {
  const ModuleListScreen({super.key});

  @override
  State<ModuleListScreen> createState() => _ModuleListScreenState();
}

class _ModuleListScreenState extends State<ModuleListScreen> {
  String searchQuery = '';
  
  final List<Map<String, dynamic>> allModules = [
    {
      'title': 'Membuka Bisnis Top-Up Game',
      'genre': 'Bisnis',
      'image': 'assets/icon/modul.png',
      'isNew': true,
    },
    {
      'title': 'Strategi Pemasaran Digital',
      'genre': 'Marketing',
      'image': 'assets/icon/modul.png',
      'isNew': false,
    },
    {
      'title': 'Manajemen Risiko Investasi',
      'genre': 'Keuangan',
      'image': 'assets/icon/modul.png',
      'isNew': false,
    },
    {
      'title': 'Cara Mengatur Gaji Pertama',
      'genre': 'Personal',
      'image': 'assets/icon/modul.png',
      'isNew': true,
    },
    {
      'title': 'Membangun Dana Darurat',
      'genre': 'Keuangan',
      'image': 'assets/icon/modul.png',
      'isNew': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    
    final filteredModules = allModules.where((module) {
      return module['title']!.toString().toLowerCase().contains(searchQuery.toLowerCase()) ||
             module['genre']!.toString().toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Color(0xFF0F172A)),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Jelajahi Modul',
          style: GoogleFonts.poppins(
            color: const Color(0xFF0F172A),
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Cari modul atau genre...',
                hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400, fontSize: 14),
                prefixIcon: Icon(LucideIcons.search, color: Colors.grey.shade400),
                filled: true,
                fillColor: const Color(0xFFF1F5F9),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          
          // Module List
          Expanded(
            child: filteredModules.isEmpty
                ? Center(
                    child: Text(
                      'Tidak ada modul yang ditemukan',
                      style: GoogleFonts.poppins(color: Colors.grey),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(20),
                    physics: const BouncingScrollPhysics(),
                    itemCount: filteredModules.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final module = filteredModules[index];
                      return _buildModuleItem(module, sw);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildModuleItem(Map<String, dynamic> module, double sw) {
    return GestureDetector(
      onTap: () => context.push('/select_topic'),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                module['image'] as String,
                width: sw * 0.2,
                height: sw * 0.2,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: sw * 0.2,
                  height: sw * 0.2,
                  color: Colors.blue.shade50,
                  child: const Icon(LucideIcons.image, color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (module['isNew'] == true)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      margin: const EdgeInsets.only(bottom: 6),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Modul Baru',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.orange.shade700,
                        ),
                      ),
                    ),
                  Text(
                    module['title'] as String,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: const Color(0xFF1E293B),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(LucideIcons.tag, size: 12, color: Colors.blue.shade400),
                      const SizedBox(width: 4),
                      Text(
                        module['genre'] as String,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.blue.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(LucideIcons.chevronRight, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../theme/colors.dart';
import '../../../shared/repositories/community_repository.dart';
import '../../../shared/repositories/user_repository.dart';

class CommunityGroupScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> groupData;
  const CommunityGroupScreen({super.key, required this.groupData});

  @override
  ConsumerState<CommunityGroupScreen> createState() => _CommunityGroupScreenState();
}

class _CommunityGroupScreenState extends ConsumerState<CommunityGroupScreen> {
  bool _isJoined = false;
  int _memberCount = 0;
  bool _isLoading = true;
  int? _currentUserId;
  final TextEditingController _postController = TextEditingController();
  bool _isPosting = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final groupId = widget.groupData['id'] as int? ?? 0;
    final profile = await ref.read(userRepositoryProvider).getCurrentUserProfile();
    if (profile != null) {
      _currentUserId = profile['id'];
      final joined = await ref.read(communityRepositoryProvider).isUserJoined(groupId, _currentUserId!);
      if (mounted) setState(() => _isJoined = joined);
    }
    
    final count = await ref.read(communityRepositoryProvider).getMembersCount(groupId);
    if (mounted) {
      setState(() {
        _memberCount = count;
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleJoin() async {
    if (_currentUserId == null) return;
    final groupId = widget.groupData['id'] as int? ?? 0;
    
    setState(() => _isLoading = true);
    try {
      if (_isJoined) {
        await ref.read(communityRepositoryProvider).leaveGroup(groupId, _currentUserId!);
      } else {
        await ref.read(communityRepositoryProvider).joinGroup(groupId, _currentUserId!);
      }
      await _loadData();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deletePost(int postId) async {
    try {
      await ref.read(communityRepositoryProvider).deletePost(postId);
      setState(() {});
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Post dihapus')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal: $e')));
    }
  }

  void _editPost(int postId, String oldContent) {
    final editController = TextEditingController(text: oldContent);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Postingan'),
        content: TextField(
          controller: editController,
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () async {
              try {
                await ref.read(communityRepositoryProvider).updatePost(postId, editController.text);
                if (mounted) {
                  Navigator.pop(context);
                  setState(() {});
                }
              } catch (e) {
                if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal: $e')));
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final groupId = widget.groupData['id'] as int? ?? 0;
    final groupName = widget.groupData['name'] ?? 'Grup Moniy';
    final groupDesc = widget.groupData['description'] ?? 'Ruang komunitas Moniy';
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Moniy',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Cover Image
            Container(
              height: 180,
              decoration: const BoxDecoration(
                color: Color(0xFF0F2027),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [const Color(0xFF0F2027), AppColors.primaryBlue.withValues(alpha: 0.8)],
                        ),
                      ),
                      child: const Center(child: Icon(LucideIcons.barChart, color: Colors.white24, size: 80)),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(LucideIcons.shield, size: 12, color: Colors.teal),
                          SizedBox(width: 4),
                          Text('Ruang Aman', style: TextStyle(color: Colors.teal, fontSize: 10, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Text(
                      groupName,
                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            
            // Group Info Card
            Transform.translate(
              offset: const Offset(0, -20),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: const [
                        Icon(LucideIcons.globe, size: 14, color: Colors.blue),
                        SizedBox(width: 4),
                        Text('Grup Publik', style: TextStyle(color: Colors.blue, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _isLoading ? null : _toggleJoin,
                      icon: Icon(_isJoined ? LucideIcons.userMinus : LucideIcons.userPlus, size: 18),
                      label: Text(_isJoined ? 'Keluar Grup' : 'Gabung Grup', style: const TextStyle(fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isJoined ? Colors.grey.shade400 : Colors.cyan.shade400,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            groupDesc,
                            style: TextStyle(color: Colors.grey.shade700, fontSize: 12, height: 1.5),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              SizedBox(
                                width: 70,
                                height: 30,
                                child: Stack(
                                  children: [
                                    Positioned(left: 0, child: CircleAvatar(radius: 12, backgroundColor: Colors.red.shade200)),
                                    Positioned(left: 15, child: CircleAvatar(radius: 12, backgroundColor: Colors.blue.shade200)),
                                    Positioned(left: 30, child: CircleAvatar(radius: 12, backgroundColor: Colors.green.shade200)),
                                  ],
                                ),
                              ),
                              Text('$_memberCount Anggota', style: TextStyle(color: Colors.grey.shade600, fontSize: 10)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Aktivitas Grup', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  
                  // Input placeholder or actual input
                  if (!_isJoined)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(radius: 16, backgroundColor: Colors.grey.shade200, child: const Icon(LucideIcons.user, size: 16, color: Colors.grey)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text('Gabung grup untuk mulai berdiskusi...', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(radius: 16, backgroundColor: Colors.blue.shade50, child: const Icon(Icons.person, color: Colors.blue, size: 16)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _postController,
                              maxLines: 3,
                              minLines: 1,
                              decoration: InputDecoration(
                                hintText: 'Mulai diskusi di sini...',
                                hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400, fontSize: 12),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              style: GoogleFonts.poppins(fontSize: 13),
                            ),
                          ),
                          IconButton(
                            onPressed: _isPosting ? null : () async {
                              if (_postController.text.trim().isEmpty) return;
                              setState(() => _isPosting = true);
                              try {
                                 await ref.read(communityRepositoryProvider).createPost(_postController.text, _currentUserId!, groupId);
                                 _postController.clear();
                                 setState(() {});
                              } catch (e) {
                                 if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal: $e')));
                              } finally {
                                 setState(() => _isPosting = false);
                              }
                            },
                            icon: _isPosting ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.send, color: Colors.blue),
                          )
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),
                  
                  // FutureBuilder for posts
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: ref.read(communityRepositoryProvider).getPostsByGroup(groupId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      final posts = snapshot.data ?? [];
                      if (posts.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text('Belum ada diskusi di grup ini.'),
                          )
                        );
                      }
                      return Column(
                        children: posts.map((post) {
                          final author = post['users'] ?? {};
                          final name = author['name'] ?? 'User';
                          final level = author['level'] ?? 1;
                          final badge = level > 5 ? 'Mentor' : 'Level $level';
                          final content = post['content'] ?? '';
                          final likes = post['likes']?.toString() ?? '0';
                          final comments = post['comments']?.toString() ?? '0';
                          // Waktu sementara pakai hardcode karena belum ada formatter date (bisa disesuaikan nanti)
                          final time = 'Baru saja';
                          final isMyPost = _currentUserId != null && _currentUserId == post['user_id'];
                          
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildPostCard(
                              name: name,
                              badge: badge,
                              time: time,
                              content: content,
                              likes: likes,
                              comments: '$comments Komentar',
                              isMyPost: isMyPost,
                              onEdit: () => _editPost(post['id'], content),
                              onDelete: () => _deletePost(post['id']),
                            ),
                          );
                        }).toList(),
                      );
                    }
                  ),
                  const SizedBox(height: 16),
                  
                  // Modul Terkait
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: const [
                            Icon(LucideIcons.bookOpen, color: AppColors.primaryBlue, size: 16),
                            SizedBox(width: 8),
                            Text('Modul Terkait', style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold, fontSize: 14)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text('Grup ini direkomendasikan untuk kamu yang sedang mengambil modul "Dasar-dasar Nabung".', style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                        const SizedBox(height: 16),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.primaryBlue),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Lihat Modul', style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Aturan Ruang Aman
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF003B95), // Dark blue
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(LucideIcons.shieldCheck, color: Colors.white, size: 16),
                            SizedBox(width: 8),
                            Text('Aturan Ruang Aman', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildRuleItem('Saling mendukung & menghargai.'),
                        const SizedBox(height: 8),
                        _buildRuleItem('Dilarang promosi pinjol/judi berkedok game.'),
                        const SizedBox(height: 8),
                        _buildRuleItem('Jaga kerahasiaan data pribadi.'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostCard({
    required String name,
    required String badge,
    required String time,
    required String content,
    bool hasAiBadge = false,
    String aiBadgeText = '',
    required String likes,
    required String comments,
    bool isLiked = false,
    bool isMyPost = false,
    VoidCallback? onEdit,
    VoidCallback? onDelete,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                radius: 16,
                child: const Icon(LucideIcons.user, size: 16, color: Colors.blue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        if (badge.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.indigo.shade50,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(badge, style: TextStyle(color: Colors.indigo.shade700, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ],
                    ),
                    Text(time, style: TextStyle(color: Colors.grey.shade500, fontSize: 10)),
                  ],
                ),
              ),
              if (isMyPost)
                PopupMenuButton<String>(
                  onSelected: (val) {
                    if (val == 'edit') onEdit?.call();
                    if (val == 'delete') onDelete?.call();
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'edit', child: Text('Edit')),
                    const PopupMenuItem(value: 'delete', child: Text('Hapus')),
                  ],
                )
              else
                const Icon(LucideIcons.moreVertical, color: Colors.grey, size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Text(content, style: const TextStyle(fontSize: 13, height: 1.4)),
          if (hasAiBadge) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.cyanAccent.shade100.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(LucideIcons.sparkles, size: 12, color: Colors.teal),
                  const SizedBox(width: 4),
                  Text(aiBadgeText, style: const TextStyle(color: Colors.teal, fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(isLiked ? Icons.favorite : LucideIcons.heart, size: 16, color: isLiked ? AppColors.primaryBlue : Colors.grey.shade600),
              const SizedBox(width: 6),
              Text(likes, style: TextStyle(color: isLiked ? AppColors.primaryBlue : Colors.grey.shade600, fontSize: 12)),
              const SizedBox(width: 16),
              Icon(LucideIcons.messageSquare, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 6),
              Text(comments, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRuleItem(String text) {
    return Row(
      children: [
        const Icon(LucideIcons.checkCircle2, color: Colors.white70, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ),
      ],
    );
  }
}

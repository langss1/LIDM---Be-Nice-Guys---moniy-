import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/repositories/community_repository.dart';
import '../../../shared/repositories/user_repository.dart';

class CommunityScreen extends ConsumerStatefulWidget {
  const CommunityScreen({super.key});

  @override
  ConsumerState<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen> {
  bool isFeedTab = true;
  final TextEditingController _postController = TextEditingController();
  bool _isLoading = false;
  int? currentUserId;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final profile = await ref.read(userRepositoryProvider).getCurrentUserProfile();
    if (mounted) setState(() => currentUserId = profile?['id']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  'assets/icon/commun.png',
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
                    child: Text(
                      'Komunitas',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ],
            ),
            
            // ── Tab Feed / Grup ───────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Container(
                height: 48,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9), // Soft grey background
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isFeedTab = true),
                        behavior: HitTestBehavior.opaque,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: isFeedTab ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: isFeedTab
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.05),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    )
                                  ]
                                : [],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Feed',
                            style: GoogleFonts.poppins(
                              color: isFeedTab ? const Color(0xFF0D6EFD) : Colors.grey.shade600,
                              fontWeight: isFeedTab ? FontWeight.w600 : FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isFeedTab = false),
                        behavior: HitTestBehavior.opaque,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: !isFeedTab ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: !isFeedTab
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.05),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    )
                                  ]
                                : [],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Grup',
                            style: GoogleFonts.poppins(
                              color: !isFeedTab ? const Color(0xFF0D6EFD) : Colors.grey.shade600,
                              fontWeight: !isFeedTab ? FontWeight.w600 : FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Switch View ───────────────────────────────────
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: isFeedTab ? _buildFeedView(ref) : _buildGroupView(ref),
            ),
          ].animate(interval: 80.ms).fade(duration: 400.ms, curve: Curves.easeOutQuart).slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuart),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
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

  // =========================================================================
  // VIEW: FEED
  // =========================================================================
  Widget _buildFeedView(WidgetRef ref) {
    return Column(
      key: const ValueKey('feed'),
      children: [
        // Input "Tulis Pendapat Anda"
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.blue.shade50,
                      child: const Icon(Icons.person, color: Colors.blue, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _postController,
                        maxLines: 4,
                        minLines: 1,
                        textInputAction: TextInputAction.newline,
                        decoration: InputDecoration(
                          hintText: 'Tulis Pendapat Anda...',
                          hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400, fontSize: 13),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.only(top: 6, bottom: 6),
                        ),
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Divider(color: Colors.grey.shade100, height: 1),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.public, color: Colors.grey.shade500, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          'Publik',
                          style: GoogleFonts.poppins(color: Colors.grey.shade500, fontSize: 12),
                        ),
                        const SizedBox(width: 2),
                        Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade500, size: 16),
                      ],
                    ),
                    // Tombol Publikasi
                    InkWell(
                      onTap: _isLoading ? null : () async {
                        if (_postController.text.trim().isEmpty) return;
                        setState(() => _isLoading = true);
                        try {
                           final profile = await ref.read(userRepositoryProvider).getCurrentUserProfile();
                           if (profile == null) throw Exception('Silahkan login kembali');
                           await ref.read(communityRepositoryProvider).createPost(_postController.text, profile['id'], null);
                           _postController.clear();
                           // Trigger rebuild to fetch new posts
                           setState(() {});
                           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Berhasil memposting!')));
                        } catch (e) {
                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal: $e')));
                        } finally {
                           setState(() => _isLoading = false);
                        }
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: _isLoading ? Colors.grey : const Color(0xFF0D6EFD),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: _isLoading 
                          ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text(
                              'Publikasi',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Area Postingan Feed
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFFF1F5F9),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: ref.read(communityRepositoryProvider).getPosts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              final posts = snapshot.data ?? [];
              if (posts.isEmpty) {
                return const Center(child: Text('Belum ada postingan.'));
              }
              
              return Column(
                children: posts.map((post) {
                   final user = post['users'] ?? {};
                   final group = post['community_groups'] ?? {};
                   final isMyPost = currentUserId != null && currentUserId == post['user_id'];
                   return Padding(
                     padding: const EdgeInsets.only(bottom: 16),
                     child: _feedCard(
                       postedIn: group['name'] ?? 'Publik',
                       authorName: user['name'] ?? 'Anonim',
                       authorLocation: post['author_location'] ?? 'Indonesia',
                       content: post['content'] ?? '',
                       likes: '${post['likes'] ?? 0}',
                       comments: '${post['comments'] ?? 0}',
                       isMyPost: isMyPost,
                       onDelete: () => _deletePost(post['id']),
                       onEdit: () => _editPost(post['id'], post['content']),
                     ),
                   );
                }).toList(),
              );
            }
          ),
        ),
      ],
    );
  }

  Widget _feedCard({
    required String postedIn,
    required String authorName,
    required String authorLocation,
    required String content,
    required String likes,
    required String comments,
    bool isMyPost = false,
    VoidCallback? onDelete,
    VoidCallback? onEdit,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
          RichText(
            text: TextSpan(
              text: 'Posted in ',
              style: GoogleFonts.poppins(color: Colors.grey.shade600, fontSize: 12),
              children: [
                TextSpan(
                  text: postedIn,
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF0D6EFD),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Divider(height: 1, color: Colors.grey.shade100),
          const SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.blue.shade100,
                child: const Icon(Icons.person, color: Colors.blue),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    authorName,
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF0D6EFD),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    authorLocation,
                    style: GoogleFonts.poppins(
                      color: Colors.grey.shade500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const Spacer(),
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
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: GoogleFonts.poppins(
              color: const Color(0xFF334155),
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Row(
                children: [
                  const Icon(Icons.favorite, color: Color(0xFF2E6FF2), size: 20),
                  const SizedBox(width: 6),
                  Text(
                    likes,
                    style: GoogleFonts.poppins(color: Colors.grey.shade600, fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Row(
                children: [
                  Icon(Icons.chat_bubble_outline, color: Colors.grey.shade600, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    comments,
                    style: GoogleFonts.poppins(color: Colors.grey.shade600, fontSize: 13),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  Icon(Icons.ios_share, color: Colors.grey.shade600, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    'Share',
                    style: GoogleFonts.poppins(color: Colors.grey.shade600, fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // VIEW: GRUP
  // =========================================================================
  Widget _buildGroupView(WidgetRef ref) {
    return Column(
      key: const ValueKey('group'),
      children: [
        // Input "Jelajahi grup"
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 20, right: 8),
                  child: Icon(Icons.search_rounded, color: Color(0xFF94A3B8), size: 22),
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Jelajahi grup',
                      hintStyle: GoogleFonts.poppins(
                        color: const Color(0xFF94A3B8),
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Color(0xFF0D6EFD),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton.icon(
              onPressed: () {
                 final nameCtrl = TextEditingController();
                 final descCtrl = TextEditingController();
                 showDialog(
                   context: context,
                   builder: (context) => AlertDialog(
                     title: const Text('Buat Grup Baru'),
                     content: Column(
                       mainAxisSize: MainAxisSize.min,
                       children: [
                         TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nama Grup')),
                         TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Deskripsi')),
                       ],
                     ),
                     actions: [
                       TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
                       ElevatedButton(
                         onPressed: () async {
                           try {
                             await ref.read(communityRepositoryProvider).createGroup(nameCtrl.text, descCtrl.text);
                             if (context.mounted) {
                               Navigator.pop(context);
                               setState(() {});
                             }
                           } catch (e) {
                             if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal: $e')));
                           }
                         },
                         child: const Text('Buat'),
                       ),
                     ],
                   )
                 );
              },
              icon: const Icon(Icons.add),
              label: const Text('Buat Grup Baru'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: const Color(0xFF0D6EFD),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))
              ),
            )
          ),
          const SizedBox(height: 24),

        // Area Daftar Grup
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFFF1F5F9),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: ref.read(communityRepositoryProvider).getGroups(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              final groups = snapshot.data ?? [];
              if (groups.isEmpty) {
                return const Center(child: Text('Belum ada grup.'));
              }
              
              return Column(
                children: groups.map((g) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _groupCard(g),
                )).toList(),
              );
            }
          ),
        ),
      ],
    );
  }

  Widget _groupCard(Map<String, dynamic> group) {
    return GestureDetector(
      onTap: () => context.push('/community_group', extra: group),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
             ClipRRect(
               borderRadius: BorderRadius.circular(12),
               child: Container(
                 width: 60, height: 60,
                 color: const Color(0xFF0D6EFD).withOpacity(0.1),
                 child: const Icon(Icons.group, color: Color(0xFF0D6EFD)),
               ),
             ),
             const SizedBox(width: 16),
             Expanded(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text(
                     group['name'] ?? '',
                     style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                   ),
                   if (group['description'] != null) ...[
                     const SizedBox(height: 4),
                     Text(
                       group['description'],
                       style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600),
                       maxLines: 2,
                       overflow: TextOverflow.ellipsis,
                     ),
                   ]
                 ],
               ),
             )
          ],
        ),
      ),
    );
  }
}

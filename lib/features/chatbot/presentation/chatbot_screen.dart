import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../data/chatbot_service.dart';
import '../../../shared/providers/supabase_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  ChatMessage({required this.text, required this.isUser});
}

class ChatbotScreen extends ConsumerStatefulWidget {
  const ChatbotScreen({super.key});

  @override
  ConsumerState<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends ConsumerState<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  late final ChatbotService _chatbotService;
  String _userName = "";

  @override
  void initState() {
    super.initState();
    _chatbotService = ChatbotService(apiKey: const String.fromEnvironment('GEMINI_API_KEY'));
    _loadUserName();
  }

  void _loadUserName() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      try {
        final data = await Supabase.instance.client.from('users').select('name').eq('email', user.email!).maybeSingle();
        if (data != null && data['name'] != null) {
          setState(() {
            _userName = data['name'].toString().split(' ')[0]; // Ambil nama depan
          });
        }
      } catch (e) {
        // Abaikan jika gagal
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _isLoading = true;
    });
    
    _controller.clear();
    _scrollToBottom();

    final response = await _chatbotService.sendMessage(text);

    setState(() {
      _messages.add(ChatMessage(text: response, isUser: false));
      _isLoading = false;
    });
    
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/Logo.png', height: 28),
            const SizedBox(width: 8),
            Text(
              'Moniy',
              style: GoogleFonts.poppins(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
            children: [
              // Header kosong jika belum ada pesan, atau list pesan
              Expanded(
                child: _messages.isEmpty ? _buildEmptyState() : _buildChatList(),
              ),
              _buildInputArea(),
            ],
          ),
        ),
      );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Ikon bintang (mirip logo Gemini)
          const Icon(
            Icons.auto_awesome, // Bintang ajaib
            color: Color(0xFFA78BFA), // Ungu terang
            size: 48,
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              _userName.isNotEmpty ? 'Ada yang bisa Moni bantu, $_userName?' : 'Ada yang bisa Moni bantu?',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.black87,
                fontSize: 28,
                height: 1.2,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _messages.length) {
          // Loading indicator
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Row(
              children: [
                const Icon(Icons.auto_awesome, color: Color(0xFFA78BFA), size: 20),
                const SizedBox(width: 12),
                Text(
                  'Moni sedang memikirkan...',
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          );
        }
        return _buildChatBubble(_messages[index]);
      },
    );
  }

  Widget _buildChatBubble(ChatMessage message) {
    if (message.isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(bottom: 24, left: 40),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9), // Abu-abu terang untuk user
            borderRadius: BorderRadius.circular(24),
          ),
          child: Text(
            message.text,
            style: GoogleFonts.poppins(
              color: Colors.black87,
              fontSize: 15,
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 24, right: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.auto_awesome, color: Color(0xFFA78BFA), size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                message.text,
                style: GoogleFonts.poppins(
                  color: Colors.black87,
                  fontSize: 15,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 96), // 96 padding bawah agar tidak tertutup nav bar
      decoration: const BoxDecoration(
        color: Colors.transparent, // Latar transparan untuk area input
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9), // Abu-abu terang untuk pill di tema putih
          borderRadius: BorderRadius.circular(32),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            const SizedBox(width: 12),
            const Icon(LucideIcons.plus, color: Colors.grey, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _controller,
                style: GoogleFonts.poppins(color: Colors.black87, fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'Tanya Moni...',
                  hintStyle: GoogleFonts.poppins(color: Colors.grey.shade500, fontSize: 16),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  LucideIcons.send, // Mengganti ikon mic menjadi send
                  color: const Color(0xFF4F46E5), // Warna ungu indigo agar terlihat di latar terang
                  size: 24
                ),
              ),
            ),
            const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }
}

import 'package:google_generative_ai/google_generative_ai.dart';

class ChatbotService {
  final String apiKey;
  late final GenerativeModel _model;
  late final ChatSession _chat;

  ChatbotService({required this.apiKey}) {
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: apiKey,
      systemInstruction: Content.system(
        'Anda adalah Moni, asisten AI pembelajaran keuangan yang interaktif, cerdas, dan ramah. '
        'Tugas Anda adalah membantu pengguna (terutama Gen Z dan milenial) untuk belajar tentang manajemen keuangan, menabung, investasi, dan menghindari judi online atau penipuan finansial. '
        'Gunakan bahasa Indonesia yang santai, mudah dimengerti, suportif, dan kekinian (tapi tetap profesional). '
        'Jika pengguna menanyakan hal di luar keuangan (kecuali sapaan umum), arahkan kembali pembicaraan ke topik keuangan dengan halus.'
      ),
    );
    
    // Initialize chat session
    _chat = _model.startChat();
  }

  Future<String> sendMessage(String message) async {
    try {
      final response = await _chat.sendMessage(Content.text(message));
      return response.text ?? 'Maaf, Moni tidak mengerti maksudmu. Bisa tolong ulangi?';
    } catch (e) {
      return 'Wah, sepertinya koneksi Moni sedang bermasalah. Coba lagi nanti ya! ($e)';
    }
  }
}

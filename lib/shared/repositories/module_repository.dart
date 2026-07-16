import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../providers/supabase_provider.dart';

final moduleRepositoryProvider = Provider<ModuleRepository>((ref) {
  return ModuleRepository(ref.watch(supabaseClientProvider));
});

class ModuleRepository {
  final SupabaseClient _supabase;

  ModuleRepository(this._supabase);

  Future<List<Map<String, dynamic>>> getModules() async {
    final response = await _supabase
        .from('modules')
        .select('*, module_topics(title, icon, color)')
        .order('created_at', ascending: true);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> getModulesWithProgress(int userId) async {
    final modules = await getModules();
    final progressList = await _supabase
        .from('user_module_progress')
        .select('*')
        .eq('user_id', userId);

    final progressMap = <int, Map<String, dynamic>>{};
    for (final p in progressList) {
      progressMap[p['module_id'] as int] = p;
    }

    return modules.map((m) {
      final progress = progressMap[m['id'] as int];
      return {
        ...m,
        'progress': progress?['progress'] ?? 0.0,
        'score': progress?['score'] ?? 0,
        'completed': progress?['completed_at'] != null,
      };
    }).toList();
  }

  Future<Map<String, dynamic>?> getModuleProgress(int userId, int moduleId) async {
    final response = await _supabase
        .from('user_module_progress')
        .select('*')
        .eq('user_id', userId)
        .eq('module_id', moduleId)
        .maybeSingle();
    return response;
  }

  Future<void> saveModuleProgress({
    required int userId,
    required int moduleId,
    required int score,
    required double progress,
    bool completed = false,
  }) async {
    final existing = await getModuleProgress(userId, moduleId);
    if (existing == null) {
      await _supabase.from('user_module_progress').insert({
        'user_id': userId,
        'module_id': moduleId,
        'score': score,
        'progress': progress,
        if (completed) 'completed_at': DateTime.now().toIso8601String(),
      });
    } else {
      await _supabase.from('user_module_progress').update({
        'score': score,
        'progress': progress,
        if (completed) 'completed_at': DateTime.now().toIso8601String(),
      }).eq('user_id', userId).eq('module_id', moduleId);
    }

    // Juga update XP user jika selesai
    if (completed) {
      final xpGain = score;
      await _supabase.rpc('increment_user_xp', params: {
        'uid': userId,
        'xp_amount': xpGain,
      });
    }
  }
}

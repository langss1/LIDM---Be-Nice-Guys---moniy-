import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../providers/supabase_provider.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(ref.watch(supabaseClientProvider));
});

class UserRepository {
  final SupabaseClient _supabase;

  UserRepository(this._supabase);

  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    final user = _supabase.auth.currentUser;
    if (user == null || user.email == null) return null;

    final response = await _supabase
        .from('users')
        .select('*')
        .eq('email', user.email!)
        .maybeSingle();
    return response;
  }

  Future<Map<String, dynamic>> getUserStats() async {
    final profile = await getCurrentUserProfile();
    if (profile == null) return {};

    // Get module progress
    final progressResp = await _supabase
        .from('user_module_progress')
        .select('*')
        .eq('user_id', profile['id']);
        
    // Get badges
    final badgesResp = await _supabase
        .from('user_badges')
        .select('*, badges(*)')
        .eq('user_id', profile['id']);

    // Get total modules
    final modulesResp = await _supabase.from('modules').select('id');
    final totalModules = modulesResp.length;

    return {
      'profile': profile,
      'progress': progressResp,
      'badges': badgesResp,
      'total_modules': totalModules,
    };
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../providers/supabase_provider.dart';

final communityRepositoryProvider = Provider<CommunityRepository>((ref) {
  return CommunityRepository(ref.watch(supabaseClientProvider));
});

class CommunityRepository {
  final SupabaseClient _supabase;

  CommunityRepository(this._supabase);

  Future<List<Map<String, dynamic>>> getGroups() async {
    final response = await _supabase
        .from('community_groups')
        .select('*')
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> getPosts() async {
    final response = await _supabase
        .from('community_posts')
        .select('*, users(name, avatar, level), community_groups(name)')
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> getPostsByGroup(int groupId) async {
    final response = await _supabase
        .from('community_posts')
        .select('*, users(name, avatar, level), community_groups(name)')
        .eq('group_id', groupId)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> createPost(String content, int userId, int? groupId) async {
    await _supabase.from('community_posts').insert({
      'content': content,
      'user_id': userId,
      'group_id': groupId,
    });
  }

  Future<void> updatePost(int postId, String content) async {
    await _supabase.from('community_posts').update({'content': content}).eq('id', postId);
  }

  Future<void> deletePost(int postId) async {
    await _supabase.from('community_posts').delete().eq('id', postId);
  }

  Future<void> createGroup(String name, String description) async {
    await _supabase.from('community_groups').insert({
      'name': name,
      'description': description,
    });
  }

  Future<void> joinGroup(int groupId, int userId) async {
    await _supabase.from('group_members').insert({
      'group_id': groupId,
      'user_id': userId,
    });
  }

  Future<void> leaveGroup(int groupId, int userId) async {
    await _supabase
        .from('group_members')
        .delete()
        .eq('group_id', groupId)
        .eq('user_id', userId);
  }

  Future<bool> isUserJoined(int groupId, int userId) async {
    final response = await _supabase
        .from('group_members')
        .select('id')
        .eq('group_id', groupId)
        .eq('user_id', userId)
        .maybeSingle();
    return response != null;
  }

  Future<int> getMembersCount(int groupId) async {
    final response = await _supabase
        .from('group_members')
        .select('id')
        .eq('group_id', groupId);
    return (response as List).length;
  }
}

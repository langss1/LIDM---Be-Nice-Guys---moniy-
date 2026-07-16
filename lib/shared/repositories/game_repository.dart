import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../providers/supabase_provider.dart';

final gameRepositoryProvider = Provider<GameRepository>((ref) {
  return GameRepository(ref.watch(supabaseClientProvider));
});

// State for current scenario + selected answer index
class GameState {
  final Map<String, dynamic>? scenario;
  final int? selectedOptionIndex;
  final bool? isCorrect;
  final int moduleId;

  const GameState({
    this.scenario,
    this.selectedOptionIndex,
    this.isCorrect,
    this.moduleId = 0,
  });

  GameState copyWith({
    Map<String, dynamic>? scenario,
    int? selectedOptionIndex,
    bool? isCorrect,
    int? moduleId,
  }) {
    return GameState(
      scenario: scenario ?? this.scenario,
      selectedOptionIndex: selectedOptionIndex ?? this.selectedOptionIndex,
      isCorrect: isCorrect ?? this.isCorrect,
      moduleId: moduleId ?? this.moduleId,
    );
  }
}

class GameScenarioNotifier extends Notifier<GameState> {
  @override
  GameState build() => const GameState();

  void updateScenario(Map<String, dynamic>? scenario, int moduleId) {
    state = GameState(scenario: scenario, moduleId: moduleId);
  }

  void selectOption(int index) {
    final correctOption = state.scenario?['correct_option'] as int? ?? 0;
    final isCorrect = index == correctOption;
    state = state.copyWith(
      selectedOptionIndex: index,
      isCorrect: isCorrect,
    );
  }

  void reset() {
    state = const GameState();
  }
}

final currentGameScenarioProvider =
    NotifierProvider<GameScenarioNotifier, GameState>(() {
  return GameScenarioNotifier();
});

// Legacy provider for backward compatibility
// ignore: deprecated_member_use_from_same_package
@Deprecated('Use currentGameScenarioProvider instead')
final legacyScenarioProvider = Provider<Map<String, dynamic>?>((ref) {
  return ref.watch(currentGameScenarioProvider).scenario;
});

class GameRepository {
  final SupabaseClient _supabase;

  GameRepository(this._supabase);

  Future<Map<String, dynamic>?> getGameScenarioByModuleId(int moduleId) async {
    try {
      final response = await _supabase
          .from('game_scenarios')
          .select('*')
          .eq('module_id', moduleId)
          .maybeSingle();
      return response;
    } catch (e) {
      debugPrint('Error fetching game scenario: $e');
      return null;
    }
  }
}

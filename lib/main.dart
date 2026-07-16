import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'routing/app_router.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  
  await Supabase.initialize(
    url: 'https://yftmtiushxwqogggrdth.supabase.co',
    anonKey: 'sb_publishable_kglME0_cTVLg_eV3EKhEPQ_jbSH8vag',
  );
  
  runApp(
    const ProviderScope(
      child: MoniyApp(),
    ),
  );
}

class MoniyApp extends StatelessWidget {
  const MoniyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MONIY',
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}


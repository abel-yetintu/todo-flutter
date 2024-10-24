import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/core/dependecy_injection.dart';
import 'package:todo/core/route/rotue_generator.dart';
import 'package:todo/core/theme/app_theme.dart';
import 'package:todo/firebase_options.dart';
import 'package:todo/providers/theme_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  diInit();
  runApp(const ProviderScope(child: Todo()));
}

class Todo extends ConsumerWidget {
  const Todo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextTheme textTheme = Theme.of(context).textTheme.apply(fontFamily: 'Montserrat');
    AppTheme appTheme = AppTheme(textTheme);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ref.watch(themeNotifierProvider),
      theme: appTheme.light(),
      darkTheme: appTheme.dark(),
      navigatorKey: getIt<GlobalKey<NavigatorState>>(),
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoutes,
    );
  }
}

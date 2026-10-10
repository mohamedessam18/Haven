import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/haven_theme.dart';
import 'features/security/data/local_security_repository.dart';
import 'features/security/application/security_controller.dart';
import 'features/security/presentation/haven_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final preferences = await SharedPreferences.getInstance();
    final repository = LocalSecurityRepository(preferences);
    final state = await repository.load();
    runApp(
      HavenApp(
        controller: SecurityController(repository: repository, state: state),
      ),
    );
  } catch (_) {
    runApp(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Haven could not start. Please reopen the app.'),
          ),
        ),
      ),
    );
  }
}

class HavenApp extends StatelessWidget {
  final SecurityController controller;
  const HavenApp({super.key, required this.controller});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Haven',
    debugShowCheckedModeBanner: false,
    theme: havenTheme(),
    home: HavenShell(controller: controller),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:haven/main.dart';
import 'package:haven/features/security/data/local_security_repository.dart';
import 'package:haven/features/security/application/security_controller.dart';
import 'package:haven/features/security/domain/security.dart';
import 'package:haven/features/security/domain/security_actions.dart';

void main() {
  test(
    'Safety alerts clear without changing door access or protection mode',
    () {
      final actions = SecurityActions();
      var state = initialSecurityState();
      state = actions.changeMode(state, ProtectionMode.away);
      state = actions.toggleDevice(state, 'door');
      state = actions.toggleDevice(state, 'smoke');
      expect(state.hasAlerts, true);
      state = actions.clearAlerts(state);
      expect(state.hasAlerts, false);
      expect(state.unlocked, true);
      expect(state.mode, ProtectionMode.away);
    },
  );
  test(
    'Local repository restores mode, sensor states and event history',
    () async {
      SharedPreferences.setMockInitialValues({});
      final repo = LocalSecurityRepository(
        await SharedPreferences.getInstance(),
      );
      final actions = SecurityActions();
      final state = actions.toggleDevice(
        actions.changeMode(initialSecurityState(), ProtectionMode.away),
        'water',
      );
      await repo.save(state);
      final restored = await repo.load();
      expect(restored.mode, ProtectionMode.away);
      expect(restored.devices.firstWhere((d) => d.id == 'water').active, true);
      expect(restored.events.first.title, 'Water sensor: test alert');
    },
  );
  testWidgets(
    'Mobile navigation, disarm confirmation and device controls work',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      SharedPreferences.setMockInitialValues({});
      final repo = LocalSecurityRepository(
        await SharedPreferences.getInstance(),
      );
      final controller = SecurityController(
        repository: repo,
        state: await repo.load(),
      );
      await tester.pumpWidget(HavenApp(controller: controller));
      await tester.pumpAndSettle();
      expect(find.text('Home, protected.'), findsOneWidget);
      await tester.ensureVisible(find.text('Disarmed'));
      await tester.tap(find.text('Disarmed'));
      await tester.pumpAndSettle();
      expect(find.text('Disarm your home?'), findsOneWidget);
      await tester.tap(find.text('Keep protecting'));
      await tester.pumpAndSettle();
      expect(controller.state.mode, ProtectionMode.stay);
      await tester.tap(find.text('Devices'));
      await tester.pumpAndSettle();
      expect(find.text('Your devices.'), findsOneWidget);
      await tester.tap(find.text('Front door'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Unlock door'));
      await tester.pumpAndSettle();
      expect(find.text('Lock door'), findsOneWidget);
      expect(controller.state.unlocked, true);
      expect(tester.takeException(), isNull);
    },
  );
}

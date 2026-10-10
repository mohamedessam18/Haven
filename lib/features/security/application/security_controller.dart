import 'package:flutter/foundation.dart';
import '../domain/security.dart';
import '../domain/security_actions.dart';

class SecurityController extends ChangeNotifier {
  final SecurityRepository repository;
  final SecurityActions actions;
  SecurityState state;
  Future<void> _pending = Future.value();
  String? persistenceError;
  SecurityController({
    required this.repository,
    required this.state,
    SecurityActions? actions,
  }) : actions = actions ?? SecurityActions();
  void _commit(SecurityState next) {
    state = next;
    notifyListeners();
    _pending = _pending.then((_) async {
      try {
        await repository.save(next);
        persistenceError = null;
      } catch (_) {
        persistenceError = 'Your change could not be saved on this device.';
        notifyListeners();
      }
    });
  }

  void changeMode(ProtectionMode mode) =>
      _commit(actions.changeMode(state, mode));
  void toggleDevice(String id) => _commit(actions.toggleDevice(state, id));
  void clearAlerts() => _commit(actions.clearAlerts(state));
  void toggleNotifications() =>
      _commit(state.copyWith(notifications: !state.notifications));
}

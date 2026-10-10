import 'security.dart';

class SecurityActions {
  SecurityState _record(
    SecurityState state,
    String title,
    String detail, {
    bool alert = false,
  }) => state.copyWith(
    events: [
      SecurityEvent(
        title: title,
        detail: detail,
        time: DateTime.now(),
        alert: alert,
      ),
      ...state.events,
    ].take(60).toList(),
  );
  SecurityState changeMode(SecurityState state, ProtectionMode mode) =>
      state.mode == mode
      ? state
      : _record(
          state.copyWith(mode: mode),
          'Switched to ${modeLabel(mode)} mode',
          modeDescription(mode),
        );
  SecurityState toggleDevice(SecurityState state, String id) {
    final device = state.devices.firstWhere((d) => d.id == id);
    final updated = device.copyWith(active: !device.active);
    return _record(
      state.copyWith(
        devices: state.devices.map((d) => d.id == id ? updated : d).toList(),
      ),
      device.type == DeviceType.lock
          ? 'Front door ${updated.status.toLowerCase()}'
          : '${device.name}: ${updated.active ? 'test alert' : 'all clear'}',
      '${device.room} · Demo simulation',
      alert: device.type != DeviceType.lock && updated.active,
    );
  }

  SecurityState clearAlerts(SecurityState state) => _record(
    state.copyWith(
      devices: state.devices
          .map((d) => d.type == DeviceType.lock ? d : d.copyWith(active: false))
          .toList(),
    ),
    'Test alerts cleared',
    'All safety sensors are back to normal',
  );
}

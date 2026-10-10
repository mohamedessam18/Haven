import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/security.dart';

SecurityState initialSecurityState() {
  final now = DateTime.now();
  return SecurityState(
    mode: ProtectionMode.stay,
    devices: const [
      SecurityDevice(
        id: 'door',
        name: 'Front door',
        room: 'Entrance',
        reading: 'Locked',
        type: DeviceType.lock,
        battery: 96,
      ),
      SecurityDevice(
        id: 'motion',
        name: 'Motion sensor',
        room: 'Living room',
        reading: 'No motion',
        type: DeviceType.motion,
        battery: 89,
      ),
      SecurityDevice(
        id: 'smoke',
        name: 'Smoke detector',
        room: 'Kitchen',
        reading: 'Clear air',
        type: DeviceType.smoke,
        battery: 100,
      ),
      SecurityDevice(
        id: 'water',
        name: 'Water sensor',
        room: 'Bathroom',
        reading: 'Dry & clear',
        type: DeviceType.water,
        battery: 92,
      ),
      SecurityDevice(
        id: 'gas',
        name: 'Gas detector',
        room: 'Kitchen',
        reading: 'Normal level',
        type: DeviceType.gas,
        battery: 98,
      ),
      SecurityDevice(
        id: 'infrared',
        name: 'Infrared sensor',
        room: 'Hallway',
        reading: 'No movement',
        type: DeviceType.infrared,
        battery: 94,
      ),
      SecurityDevice(
        id: 'siren',
        name: 'Security siren',
        room: 'Entrance',
        reading: 'Standby',
        type: DeviceType.siren,
        battery: 100,
      ),
    ],
    events: [
      SecurityEvent(
        title: 'Your home is in Stay mode',
        detail: 'Perimeter protection is on',
        time: now.subtract(const Duration(minutes: 10)),
      ),
      SecurityEvent(
        title: 'Front door locked',
        detail: 'Entrance · Smart lock',
        time: now.subtract(const Duration(minutes: 35)),
      ),
      SecurityEvent(
        title: 'All sensors checked in',
        detail: '7 devices connected and healthy',
        time: now.subtract(const Duration(hours: 1)),
      ),
    ],
  );
}

class LocalSecurityRepository implements SecurityRepository {
  final SharedPreferences preferences;
  LocalSecurityRepository(this.preferences);
  static const key = 'haven.flutter.security.v1';
  @override
  Future<SecurityState> load() async {
    final initial = initialSecurityState();
    try {
      final raw = preferences.getString(key);
      if (raw == null) return initial;
      final data = jsonDecode(raw) as Map<String, dynamic>;
      final active = Map<String, dynamic>.from(data['active'] as Map);
      return initial.copyWith(
        mode: ProtectionMode.values.byName(data['mode'] as String),
        notifications: data['notifications'] as bool,
        devices: initial.devices
            .map((d) => d.copyWith(active: active[d.id] as bool? ?? false))
            .toList(),
        events: (data['events'] as List)
            .map(
              (e) => SecurityEvent(
                title: e['title'] as String,
                detail: e['detail'] as String,
                time: DateTime.parse(e['time'] as String),
                alert: e['alert'] as bool,
              ),
            )
            .toList(),
      );
    } catch (_) {
      return initial;
    }
  }

  @override
  Future<void> save(SecurityState state) async {
    final saved = await preferences.setString(
      key,
      jsonEncode({
        'mode': state.mode.name,
        'notifications': state.notifications,
        'active': {for (final d in state.devices) d.id: d.active},
        'events': state.events
            .map(
              (e) => {
                'title': e.title,
                'detail': e.detail,
                'time': e.time.toIso8601String(),
                'alert': e.alert,
              },
            )
            .toList(),
      }),
    );
    if (!saved) throw StateError('Could not save your changes');
  }
}

enum ProtectionMode { stay, away, disarmed }

enum DeviceType { lock, motion, smoke, water, gas, infrared, siren }

class SecurityDevice {
  final String id, name, room, reading;
  final DeviceType type;
  final int battery;
  final bool active;
  const SecurityDevice({
    required this.id,
    required this.name,
    required this.room,
    required this.reading,
    required this.type,
    required this.battery,
    this.active = false,
  });
  SecurityDevice copyWith({bool? active}) => SecurityDevice(
    id: id,
    name: name,
    room: room,
    reading: reading,
    type: type,
    battery: battery,
    active: active ?? this.active,
  );
  String get status => type == DeviceType.lock
      ? (active ? 'Unlocked' : 'Locked')
      : active
      ? 'Test alert active'
      : reading;
}

class SecurityEvent {
  final String title, detail;
  final DateTime time;
  final bool alert;
  const SecurityEvent({
    required this.title,
    required this.detail,
    required this.time,
    this.alert = false,
  });
}

class SecurityState {
  final ProtectionMode mode;
  final List<SecurityDevice> devices;
  final List<SecurityEvent> events;
  final bool notifications;
  const SecurityState({
    required this.mode,
    required this.devices,
    required this.events,
    this.notifications = true,
  });
  bool get hasAlerts =>
      devices.any((d) => d.type != DeviceType.lock && d.active);
  bool get unlocked =>
      devices.firstWhere((d) => d.type == DeviceType.lock).active;
  SecurityState copyWith({
    ProtectionMode? mode,
    List<SecurityDevice>? devices,
    List<SecurityEvent>? events,
    bool? notifications,
  }) => SecurityState(
    mode: mode ?? this.mode,
    devices: devices ?? this.devices,
    events: events ?? this.events,
    notifications: notifications ?? this.notifications,
  );
}

abstract interface class SecurityRepository {
  Future<SecurityState> load();
  Future<void> save(SecurityState state);
}

String modeLabel(ProtectionMode mode) => switch (mode) {
  ProtectionMode.stay => 'Stay',
  ProtectionMode.away => 'Away',
  ProtectionMode.disarmed => 'Disarmed',
};
String modeDescription(ProtectionMode mode) => switch (mode) {
  ProtectionMode.stay => 'Doors protected. Move freely inside.',
  ProtectionMode.away => 'All sensors are watching over your home.',
  ProtectionMode.disarmed => 'Safety sensors remain on, always.',
};

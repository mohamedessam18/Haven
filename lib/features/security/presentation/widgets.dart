import 'package:flutter/material.dart';
import '../../../core/theme/haven_theme.dart';
import '../domain/security.dart';

IconData deviceIcon(DeviceType type) => switch (type) {
  DeviceType.lock => Icons.lock_outline_rounded,
  DeviceType.motion => Icons.sensors_rounded,
  DeviceType.smoke => Icons.local_fire_department_outlined,
  DeviceType.water => Icons.water_drop_outlined,
  DeviceType.gas => Icons.air_rounded,
  DeviceType.infrared => Icons.center_focus_strong_outlined,
  DeviceType.siren => Icons.notifications_active_outlined,
};
IconData modeIcon(ProtectionMode mode) => switch (mode) {
  ProtectionMode.stay => Icons.home_outlined,
  ProtectionMode.away => Icons.shield_outlined,
  ProtectionMode.disarmed => Icons.lock_open_rounded,
};

class Eyebrow extends StatelessWidget {
  final String text;
  const Eyebrow(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      fontSize: 9,
      letterSpacing: 1.5,
      fontWeight: FontWeight.w600,
      color: HavenColors.muted,
    ),
  );
}

class PageHeading extends StatelessWidget {
  final String eyebrow, title, subtitle;
  const PageHeading({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
  });
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Eyebrow(eyebrow),
      const SizedBox(height: 10),
      Text(
        title,
        style: const TextStyle(
          fontSize: 29,
          fontWeight: FontWeight.w700,
          letterSpacing: -1.2,
          color: HavenColors.ink,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          color: HavenColors.muted,
          height: 1.5,
        ),
      ),
    ],
  );
}

class IconTile extends StatelessWidget {
  final IconData icon;
  final double size;
  const IconTile(this.icon, {super.key, this.size = 38});
  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: HavenColors.pale,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Icon(icon, size: size * .5, color: const Color(0xFF748761)),
  );
}

class DeviceCard extends StatelessWidget {
  final SecurityDevice device;
  final VoidCallback onTap;
  const DeviceCard({super.key, required this.device, required this.onTap});
  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: '${device.name}, ${device.room}, ${device.status}',
    child: Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(17),
        side: BorderSide(
          color: device.active ? const Color(0xFFD5B875) : HavenColors.line,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconTile(deviceIcon(device.type)),
                  const Spacer(),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: device.active
                          ? const Color(0xFFC58D35)
                          : const Color(0xFF72915D),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                device.room,
                style: const TextStyle(fontSize: 10, color: HavenColors.muted),
              ),
              const SizedBox(height: 5),
              Text(
                device.name,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      device.status,
                      style: const TextStyle(
                        fontSize: 11,
                        color: HavenColors.muted,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 16,
                    color: HavenColors.muted,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class SectionTitle extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onTap;
  const SectionTitle(this.title, {super.key, this.action, this.onTap});
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: -.4,
          ),
        ),
      ),
      if (action != null)
        TextButton(
          onPressed: onTap,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(action!, style: const TextStyle(fontSize: 11)),
              const SizedBox(width: 6),
              const Icon(Icons.arrow_forward_rounded, size: 14),
            ],
          ),
        ),
    ],
  );
}

class EventTile extends StatelessWidget {
  final SecurityEvent event;
  const EventTile(this.event, {super.key});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 18),
    child: Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: event.alert ? const Color(0xFFF6EAD1) : HavenColors.pale,
          ),
          child: Icon(
            event.alert
                ? Icons.notifications_active_outlined
                : Icons.check_rounded,
            size: 16,
            color: event.alert
                ? const Color(0xFFB48B48)
                : const Color(0xFF7F9467),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                event.detail,
                style: const TextStyle(
                  fontSize: 10,
                  color: HavenColors.muted,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          TimeOfDay.fromDateTime(event.time).format(context),
          style: const TextStyle(fontSize: 9, color: HavenColors.muted),
        ),
      ],
    ),
  );
}

class Paper extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  const Paper({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 17),
  });
  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(17),
      border: Border.all(color: HavenColors.line),
    ),
    child: child,
  );
}

class DeviceGrid extends StatelessWidget {
  final List<SecurityDevice> devices;
  final ValueChanged<SecurityDevice> onDevice;
  const DeviceGrid({super.key, required this.devices, required this.onDevice});
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final columns = constraints.maxWidth > 700
          ? 3
          : constraints.maxWidth < 300
          ? 1
          : 2;
      final width = (constraints.maxWidth - (columns - 1) * 12) / columns;
      return Wrap(
        spacing: 12,
        runSpacing: 12,
        children: devices
            .map(
              (d) => SizedBox(
                width: width,
                child: DeviceCard(device: d, onTap: () => onDevice(d)),
              ),
            )
            .toList(),
      );
    },
  );
}

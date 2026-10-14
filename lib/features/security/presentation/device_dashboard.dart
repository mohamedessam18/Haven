import 'package:flutter/material.dart';
import '../../../core/theme/haven_theme.dart';
import '../domain/security.dart';

class DeviceDashboard extends StatelessWidget {
  final SecurityState state;
  final VoidCallback onTap;
  const DeviceDashboard({super.key, required this.state, required this.onTap});

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: 'Dashboard: view all ${state.devices.length} devices',
    child: Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: HavenColors.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Dashboard',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    'View all ${state.devices.length}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: HavenColors.green,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 16,
                    color: HavenColors.green,
                  ),
                ],
              ),
              const SizedBox(height: 7),
              const Text(
                'Device battery overview',
                style: TextStyle(fontSize: 11, color: HavenColors.muted),
              ),
              const SizedBox(height: 18),
              DeviceGaugeGrid(devices: state.devices.take(4).toList()),
            ],
          ),
        ),
      ),
    ),
  );
}

class DeviceGaugeGrid extends StatelessWidget {
  final List<SecurityDevice> devices;
  const DeviceGaugeGrid({super.key, required this.devices});
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final columns = constraints.maxWidth >= 500 ? 4 : 2;
      final width = (constraints.maxWidth - (columns - 1) * 12) / columns;
      return Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          for (final device in devices)
            Container(
              width: width,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
              decoration: BoxDecoration(
                color: HavenColors.pale,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: 76,
                    height: 76,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox.expand(
                          child: CircularProgressIndicator(
                            value: device.battery.clamp(0, 100) / 100,
                            strokeWidth: 6,
                            color: HavenColors.green,
                            backgroundColor: HavenColors.line,
                          ),
                        ),
                        Text(
                          '${device.battery}%',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: HavenColors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    device.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    device.room,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 10,
                      color: HavenColors.muted,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Battery · ${device.online ? 'Online' : 'Offline'}',
                    style: const TextStyle(
                      fontSize: 10,
                      color: HavenColors.muted,
                    ),
                  ),
                ],
              ),
            ),
        ],
      );
    },
  );
}

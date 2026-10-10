import 'package:flutter/material.dart';
import '../../../core/theme/haven_theme.dart';
import '../domain/security.dart';
import 'widgets.dart';

class DevicesScreen extends StatefulWidget {
  final SecurityState state;
  final ValueChanged<SecurityDevice> onDevice;
  const DevicesScreen({super.key, required this.state, required this.onDevice});
  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  String room = 'All';
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    key: const PageStorageKey('devices'),
    padding: const EdgeInsets.fromLTRB(22, 26, 22, 30),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PageHeading(
          eyebrow: 'EVERY CORNER, COVERED',
          title: 'Your devices.',
          subtitle: 'Small details. A safer home.',
        ),
        const SizedBox(height: 23),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children:
                ['All', ...widget.state.devices.map((d) => d.room).toSet()]
                    .map(
                      (r) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(r, style: const TextStyle(fontSize: 11)),
                          selected: room == r,
                          showCheckmark: false,
                          onSelected: (_) => setState(() => room = r),
                          selectedColor: HavenColors.green,
                          labelStyle: TextStyle(
                            color: room == r ? Colors.white : HavenColors.muted,
                          ),
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: HavenColors.line),
                          shape: const StadiumBorder(),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ),
        const SizedBox(height: 20),
        DeviceGrid(
          devices: widget.state.devices
              .where((d) => room == 'All' || room == d.room)
              .toList(),
          onDevice: widget.onDevice,
        ),
        const SizedBox(height: 27),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_rounded, size: 16, color: HavenColors.muted),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                'All 7 devices are connected to your home hub.',
                style: TextStyle(fontSize: 10, color: HavenColors.muted),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

import 'package:flutter/material.dart';
import '../domain/security.dart';
import 'device_dashboard.dart';
import 'widgets.dart';

class DashboardScreen extends StatelessWidget {
  final SecurityState state;
  final VoidCallback onBack;
  const DashboardScreen({super.key, required this.state, required this.onBack});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    key: const PageStorageKey('dashboard'),
    padding: const EdgeInsets.fromLTRB(22, 16, 22, 30),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton.icon(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back_rounded, size: 18),
          label: const Text('Back to Home'),
        ),
        const SizedBox(height: 12),
        PageHeading(
          eyebrow: 'ALL YOUR DEVICES AT A GLANCE',
          title: 'Dashboard.',
          subtitle:
              'Battery levels and connection status for all ${state.devices.length} devices.',
        ),
        const SizedBox(height: 24),
        DeviceGaugeGrid(devices: state.devices),
      ],
    ),
  );
}

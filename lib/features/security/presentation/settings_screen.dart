import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/haven_theme.dart';
import '../domain/security.dart';
import 'widgets.dart';

class SettingsScreen extends StatelessWidget {
  final SecurityState state;
  final VoidCallback onNotifications;
  const SettingsScreen({
    super.key,
    required this.state,
    required this.onNotifications,
  });
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    key: const PageStorageKey('settings'),
    padding: const EdgeInsets.fromLTRB(22, 26, 22, 30),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PageHeading(
          eyebrow: 'MAKE YOURSELF AT HOME',
          title: 'Settings.',
          subtitle: 'The way you like things.',
        ),
        const SizedBox(height: 26),
        Paper(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Color(0xFFE9E9DB),
                    foregroundColor: Color(0xFF727A5E),
                    child: Text('A'),
                  ),
                  SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Alex Morgan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Home owner · Demo profile',
                          style: TextStyle(
                            fontSize: 10,
                            color: HavenColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              const Divider(),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                secondary: const IconTile(Icons.notifications_outlined),
                title: const Text(
                  'In-app notifications',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
                subtitle: const Text(
                  'Show confirmations for your actions',
                  style: TextStyle(fontSize: 10, color: HavenColors.muted),
                ),
                value: state.notifications,
                onChanged: (_) => onNotifications(),
              ),
              const Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const IconTile(Icons.info_outline_rounded),
                title: const Text(
                  'About Haven',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
                subtitle: const Text(
                  'A calmer, safer everyday',
                  style: TextStyle(fontSize: 10, color: HavenColors.muted),
                ),
                trailing: const Icon(Icons.chevron_right_rounded, size: 18),
                onTap: () => showDialog<void>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Home, protected.'),
                    content: const Text(
                      'Haven is a Flutter interface preview. Device readings, lock controls and activity are simulated and saved on this device. No real home monitoring, push alerts or emergency notifications are connected.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Got it'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 50),
        Center(
          child: Column(
            children: [
              SvgPicture.asset('assets/brand/logo.svg', width: 39),
              const SizedBox(height: 12),
              const Text(
                'haven.',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Home, protected.',
                style: TextStyle(fontSize: 11, color: HavenColors.muted),
              ),
              const SizedBox(height: 23),
              const Text(
                'FLUTTER PREVIEW · VERSION 1.0',
                style: TextStyle(
                  fontSize: 8,
                  letterSpacing: 1,
                  color: HavenColors.muted,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

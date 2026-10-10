import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/haven_theme.dart';
import '../domain/security.dart';
import 'widgets.dart';

class HomeScreen extends StatelessWidget {
  final SecurityState state;
  final ValueChanged<ProtectionMode> onMode;
  final ValueChanged<SecurityDevice> onDevice;
  final ValueChanged<int> onNavigate;
  const HomeScreen({
    super.key,
    required this.state,
    required this.onMode,
    required this.onDevice,
    required this.onNavigate,
  });
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    key: const PageStorageKey('home'),
    padding: const EdgeInsets.fromLTRB(22, 26, 22, 30),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PageHeading(
          eyebrow: 'YOUR EVERYDAY PEACE OF MIND',
          title: 'Home, protected.',
          subtitle: 'A little reassurance. Wherever you are.',
        ),
        const SizedBox(height: 26),
        _Hero(state: state),
        const SizedBox(height: 28),
        const SectionTitle('Protection mode'),
        const SizedBox(height: 5),
        Text(
          modeDescription(state.mode),
          style: const TextStyle(fontSize: 11, color: HavenColors.muted),
        ),
        const SizedBox(height: 16),
        _ModeSelector(mode: state.mode, onMode: onMode),
        const SizedBox(height: 23),
        SectionTitle(
          'Your devices  ·  ${state.devices.length}',
          action: 'View all',
          onTap: () => onNavigate(1),
        ),
        const SizedBox(height: 8),
        DeviceGrid(devices: state.devices.take(4).toList(), onDevice: onDevice),
        const SizedBox(height: 22),
        SectionTitle(
          'Recent activity',
          action: 'See all',
          onTap: () => onNavigate(2),
        ),
        const SizedBox(height: 8),
        Paper(
          child: Column(
            children: [
              for (final (i, event) in state.events.take(3).indexed) ...[
                if (i > 0) const Divider(height: 1),
                EventTile(event),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(19),
          decoration: BoxDecoration(
            color: HavenColors.pale,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Row(
            children: [
              Icon(Icons.shield_outlined, color: Color(0xFF819768), size: 28),
              SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'A quieter kind of security.',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'We’ll let you know when something needs you.',
                      style: TextStyle(
                        fontSize: 10,
                        color: HavenColors.muted,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Center(
          child: Text(
            'INTERACTIVE PREVIEW · SIMULATED DEVICES',
            style: TextStyle(
              fontSize: 8,
              letterSpacing: .7,
              color: HavenColors.muted,
            ),
          ),
        ),
      ],
    ),
  );
}

class _Hero extends StatelessWidget {
  final SecurityState state;
  const _Hero({required this.state});
  @override
  Widget build(BuildContext context) {
    final paused = state.mode == ProtectionMode.disarmed;
    final label = state.hasAlerts
        ? 'ATTENTION NEEDED'
        : paused
        ? 'PROTECTION PAUSED'
        : state.unlocked
        ? 'DOOR UNLOCKED'
        : 'ALL IS WELL';
    final title = state.hasAlerts
        ? 'Let’s check\non your home.'
        : paused
        ? 'At home.\nAt your ease.'
        : state.unlocked
        ? 'Your home.\nYour way.'
        : 'Your safe\nplace is safe.';
    final description = state.hasAlerts
        ? 'A simulated sensor alert is active.'
        : paused
        ? 'Security protection is paused.\nSafety sensors are still watching.'
        : state.unlocked
        ? 'Your front door is unlocked.\nTap the lock to secure it.'
        : 'Everything’s looking good at home.\nWe’ll keep an eye on things.';
    return AnimatedContainer(
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : const Duration(milliseconds: 300),
      width: double.infinity,
      decoration: BoxDecoration(
        color: state.hasAlerts ? const Color(0xFFF0E5CC) : HavenColors.lime,
        borderRadius: BorderRadius.circular(23),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F7EC),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 5,
                        height: 5,
                        decoration: const BoxDecoration(
                          color: Color(0xFF72915D),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 7),
                      Text(
                        label,
                        style: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 17),
                AnimatedSize(
                  duration: const Duration(milliseconds: 250),
                  alignment: Alignment.topLeft,
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 32,
                      height: 1.15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1.3,
                    ),
                  ),
                ),
                const SizedBox(height: 13),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 11,
                    height: 1.7,
                    color: HavenColors.muted,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 156,
            child: Stack(
              children: [
                Positioned(
                  right: -4,
                  bottom: -18,
                  child: SvgPicture.asset(
                    'assets/brand/house.svg',
                    width: 255,
                    height: 175,
                  ),
                ),
                Positioned(
                  right: 20,
                  bottom: 39,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          state.hasAlerts
                              ? Icons.notifications_outlined
                              : Icons.check_rounded,
                          size: 13,
                          color: HavenColors.green,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          state.hasAlerts
                              ? 'Check sensors'
                              : paused
                              ? 'Safety sensors on'
                              : state.unlocked
                              ? 'Door unlocked'
                              : 'Home is secure',
                          style: const TextStyle(fontSize: 9),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 0, 25, 23),
            child: Row(
              children: [
                const Icon(
                  Icons.shield_outlined,
                  size: 15,
                  color: HavenColors.muted,
                ),
                const SizedBox(width: 7),
                Flexible(
                  child: Text(
                    '${modeLabel(state.mode)} mode  ·  ${state.devices.length} devices online',
                    style: const TextStyle(
                      fontSize: 10,
                      color: HavenColors.muted,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeSelector extends StatelessWidget {
  final ProtectionMode mode;
  final ValueChanged<ProtectionMode> onMode;
  const _ModeSelector({required this.mode, required this.onMode});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(5),
    decoration: BoxDecoration(
      color: HavenColors.pale,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: HavenColors.line),
    ),
    child: Row(
      children: [
        for (final item in ProtectionMode.values)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Semantics(
                selected: mode == item,
                child: AnimatedContainer(
                  duration: MediaQuery.disableAnimationsOf(context)
                      ? Duration.zero
                      : const Duration(milliseconds: 240),
                  decoration: BoxDecoration(
                    color: mode == item
                        ? HavenColors.green
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: mode == item
                          ? Colors.white
                          : HavenColors.muted,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () => onMode(item),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(modeIcon(item), size: 17),
                        const SizedBox(width: 7),
                        Flexible(
                          child: Text(
                            modeLabel(item),
                            style: const TextStyle(fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    ),
  );
}

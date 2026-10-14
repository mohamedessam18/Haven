import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/haven_theme.dart';
import '../application/security_controller.dart';
import '../domain/security.dart';
import 'widgets.dart';
import 'home_screen.dart';
import 'dashboard_screen.dart';
import 'devices_screen.dart';
import 'activity_screen.dart';
import 'settings_screen.dart';

class HavenShell extends StatefulWidget {
  final SecurityController controller;
  const HavenShell({super.key, required this.controller});
  @override
  State<HavenShell> createState() => _HavenShellState();
}

class _HavenShellState extends State<HavenShell> {
  int page = 0;
  final bucket = PageStorageBucket();
  void navigate(int next) {
    HapticFeedback.selectionClick();
    setState(() => page = next);
  }

  void notify(String message) {
    if (!widget.controller.state.notifications) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  Future<void> changeMode(ProtectionMode mode) async {
    if (mode == widget.controller.state.mode) return;
    if (mode == ProtectionMode.disarmed) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          icon: const Icon(Icons.lock_open_rounded),
          title: const Text('Disarm your home?'),
          content: const Text(
            'Motion and door protection will pause. Smoke, gas and water sensors stay active.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Keep protecting'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Disarm'),
            ),
          ],
        ),
      );
      if (!mounted || confirmed != true) return;
    }
    HapticFeedback.lightImpact();
    widget.controller.changeMode(mode);
    notify('${modeLabel(mode)} mode is on');
  }

  void deviceDetails(SecurityDevice device) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) => ListenableBuilder(
        listenable: widget.controller,
        builder: (context, _) {
          final current = widget.controller.state.devices.firstWhere(
            (d) => d.id == device.id,
          );
          final isLock = current.type == DeviceType.lock;
          return SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                26,
                0,
                26,
                24 + MediaQuery.viewInsetsOf(context).bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconTile(deviceIcon(current.type), size: 58),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.pop(sheetContext),
                        tooltip: 'Close device details',
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Eyebrow(current.room.toUpperCase()),
                  const SizedBox(height: 9),
                  Text(
                    current.name,
                    style: const TextStyle(
                      fontSize: 27,
                      letterSpacing: -.8,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    current.status,
                    style: const TextStyle(
                      fontSize: 13,
                      color: HavenColors.muted,
                    ),
                  ),
                  const SizedBox(height: 23),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.wifi_rounded,
                          size: 16,
                          color: HavenColors.green,
                        ),
                        const SizedBox(width: 7),
                        const Text('Online', style: TextStyle(fontSize: 11)),
                        const SizedBox(width: 28),
                        const Icon(
                          Icons.battery_5_bar_rounded,
                          size: 18,
                          color: HavenColors.green,
                        ),
                        const SizedBox(width: 7),
                        Text(
                          '${current.battery}% battery',
                          style: const TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 18),
                  Text(
                    isLock
                        ? 'Manage access to your home. This preview simulates the lock.'
                        : 'Test how a sensor alert appears in your home overview and system log.',
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.8,
                      color: HavenColors.muted,
                    ),
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 17),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        widget.controller.toggleDevice(current.id);
                      },
                      icon: Icon(
                        isLock
                            ? Icons.lock_outline_rounded
                            : Icons.sensors_rounded,
                        size: 19,
                      ),
                      label: Text(
                        isLock
                            ? current.active
                                  ? 'Lock door'
                                  : 'Unlock door'
                            : current.active
                            ? 'Clear test alert'
                            : 'Simulate alert',
                      ),
                    ),
                  ),
                  const SizedBox(height: 17),
                  const Center(
                    child: Text(
                      'Preview only · No physical device is connected',
                      style: TextStyle(fontSize: 9, color: HavenColors.muted),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.controller,
    builder: (context, _) {
      final state = widget.controller.state;
      final screens = [
        HomeScreen(
          state: state,
          onMode: changeMode,
          onDevice: deviceDetails,
          onNavigate: navigate,
        ),
        DevicesScreen(state: state, onDevice: deviceDetails),
        ActivityScreen(
          state: state,
          onClear: () {
            widget.controller.clearAlerts();
            notify('Test alerts cleared');
          },
        ),
        SettingsScreen(
          state: state,
          onNotifications: widget.controller.toggleNotifications,
        ),
        DashboardScreen(state: state, onBack: () => navigate(0)),
      ];
      return PopScope(
        canPop: page == 0,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) navigate(0);
        },
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 74,
            titleSpacing: 22,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset('assets/brand/logo.svg', width: 33),
                const SizedBox(width: 8),
                const Text(
                  'haven.',
                  style: TextStyle(
                    fontSize: 24,
                    letterSpacing: -1,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('My home'),
                    content: const Text(
                      'Hub online · 7 devices connected.\n\nThis preview includes one home with simulated devices.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Done'),
                      ),
                    ],
                  ),
                ),
                child: const Text('My home', style: TextStyle(fontSize: 11)),
              ),
              IconButton(
                tooltip: 'View system log',
                onPressed: () => navigate(2),
                icon: const Icon(Icons.notifications_none_rounded, size: 22),
              ),
              const SizedBox(width: 12),
            ],
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(1),
              child: Divider(height: 1),
            ),
          ),
          body: Column(
            children: [
              if (widget.controller.persistenceError != null)
                MaterialBanner(
                  content: Text(widget.controller.persistenceError!),
                  actions: [
                    TextButton(
                      onPressed: () {
                        widget.controller.persistenceError = null;
                        setState(() {});
                      },
                      child: const Text('Dismiss'),
                    ),
                  ],
                ),
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 760),
                    child: PageStorage(
                      bucket: bucket,
                      child: AnimatedSwitcher(
                        duration: MediaQuery.disableAnimationsOf(context)
                            ? Duration.zero
                            : const Duration(milliseconds: 220),
                        switchInCurve: Curves.easeOut,
                        transitionBuilder: (child, animation) => FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, .025),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        ),
                        child: KeyedSubtree(
                          key: ValueKey(page),
                          child: screens[page],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: DecoratedBox(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: HavenColors.line)),
            ),
            child: NavigationBar(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              indicatorColor: HavenColors.pale,
              selectedIndex: page == 4 ? 0 : page,
              onDestinationSelected: navigate,
              height: 76,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home_rounded),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.grid_view_outlined),
                  selectedIcon: Icon(Icons.grid_view_rounded),
                  label: 'Devices',
                ),
                NavigationDestination(
                  icon: Icon(Icons.timeline_rounded),
                  label: 'System Log',
                ),
                NavigationDestination(icon: _SettingsIcon(), label: 'Settings'),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class _SettingsIcon extends StatelessWidget {
  const _SettingsIcon();
  @override
  Widget build(BuildContext context) => SvgPicture.asset(
    'assets/brand/settings.svg',
    width: 24,
    height: 24,
    excludeFromSemantics: true,
    colorFilter: ColorFilter.mode(
      IconTheme.of(context).color ?? HavenColors.ink,
      BlendMode.srcIn,
    ),
  );
}

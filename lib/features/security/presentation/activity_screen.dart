import 'package:flutter/material.dart';
import '../../../core/theme/haven_theme.dart';
import '../domain/security.dart';
import 'widgets.dart';

class ActivityScreen extends StatefulWidget {
  final SecurityState state;
  final VoidCallback onClear;
  const ActivityScreen({super.key, required this.state, required this.onClear});
  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  bool onlyAlerts = false;
  @override
  Widget build(BuildContext context) {
    final events = widget.state.events
        .where((e) => !onlyAlerts || e.alert)
        .toList();
    return SingleChildScrollView(
      key: const PageStorageKey('activity'),
      padding: const EdgeInsets.fromLTRB(22, 26, 22, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeading(
            eyebrow: 'THE LITTLE THINGS, RECORDED',
            title: 'Activity.',
            subtitle: 'Know what happened, even when you weren’t home.',
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            children: [
              for (final value in [false, true])
                ChoiceChip(
                  label: Text(
                    value ? 'Test alerts' : 'All activity',
                    style: const TextStyle(fontSize: 11),
                  ),
                  selected: onlyAlerts == value,
                  showCheckmark: false,
                  selectedColor: HavenColors.green,
                  labelStyle: TextStyle(
                    color: onlyAlerts == value
                        ? Colors.white
                        : HavenColors.muted,
                  ),
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: HavenColors.line),
                  onSelected: (_) => setState(() => onlyAlerts = value),
                ),
              if (widget.state.hasAlerts)
                TextButton(
                  onPressed: widget.onClear,
                  child: const Text(
                    'Clear tests',
                    style: TextStyle(fontSize: 11),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 18),
          Paper(
            padding: const EdgeInsets.all(17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Eyebrow('RECENT EVENTS'),
                const SizedBox(height: 7),
                if (events.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 44),
                    child: Center(
                      child: Text(
                        'All quiet here.\nYour alerts will appear here.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: HavenColors.muted, height: 2),
                      ),
                    ),
                  ),
                for (final (i, event) in events.indexed) ...[
                  if (i > 0) const Divider(height: 1),
                  EventTile(event),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

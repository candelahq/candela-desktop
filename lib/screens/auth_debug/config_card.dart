import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../models/candela_config.dart';

class ConfigCard extends StatelessWidget {
  final CandelaConfig config;
  final VoidCallback? onSwitchToSolo;
  final ValueChanged<String>? onSwitchToTeam;
  const ConfigCard({super.key, required this.config, this.onSwitchToSolo, this.onSwitchToTeam});

  @override
  Widget build(BuildContext context) {
    final modeLabel = switch (config.mode) {
      CandelaMode.solo => 'Solo Mode',
      CandelaMode.soloCloud => 'Solo + Cloud',
      CandelaMode.team => 'Team Mode',
    };
    final modeColor = switch (config.mode) {
      CandelaMode.solo => CandelaColors.info,
      CandelaMode.soloCloud => CandelaColors.accent,
      CandelaMode.team => CandelaColors.success,
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.description_outlined, size: 18, color: CandelaColors.textSecondary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(config.path,
                    style: const TextStyle(fontSize: 12, fontFamily: 'SF Mono, monospace', color: CandelaColors.textSecondary)),
                ),
                if (config.lastModified != null)
                  Text(_formatTime(config.lastModified!),
                    style: const TextStyle(fontSize: 11, color: CandelaColors.textMuted)),
              ],
            ),
            const SizedBox(height: 12),
            // Mode badge (clickable) + toggle
            Row(
              children: [
                Tooltip(
                  message: 'Click to switch mode',
                  child: InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: () => _showModeDialog(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: modeColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: modeColor.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(modeLabel, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: modeColor)),
                          const SizedBox(width: 4),
                          Icon(Icons.swap_horiz, size: 12, color: modeColor),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                if (config.remote != null)
                  Expanded(child: Text(
                    config.remote!,
                    style: const TextStyle(fontSize: 11, color: CandelaColors.textSecondary),
                    overflow: TextOverflow.ellipsis,
                  )),
                if (config.providers.isNotEmpty && config.remote == null)
                  Text(
                    'Providers: ${config.providers.map((p) => p.name).join(", ")}',
                    style: const TextStyle(fontSize: 12, color: CandelaColors.textSecondary),
                  ),
              ],
            ),
            // Issues
            if (config.issues.isNotEmpty) ...[
              const SizedBox(height: 12),
              for (final issue in config.issues)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Icon(
                        issue.severity == IssueSeverity.error ? Icons.error_outline
                            : issue.severity == IssueSeverity.warning ? Icons.warning_amber_outlined
                            : Icons.info_outline,
                        size: 14,
                        color: issue.severity == IssueSeverity.error ? CandelaColors.error
                            : issue.severity == IssueSeverity.warning ? CandelaColors.warning
                            : CandelaColors.info,
                      ),
                      const SizedBox(width: 6),
                      Text(issue.message, style: TextStyle(
                        fontSize: 12,
                        color: issue.severity == IssueSeverity.error ? CandelaColors.error
                            : issue.severity == IssueSeverity.warning ? CandelaColors.warning
                            : CandelaColors.textSecondary,
                      )),
                    ],
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  void _showModeDialog(BuildContext context) {
    final isTeam = config.mode == CandelaMode.team;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: CandelaColors.bgSecondary,
        title: const Text('Switch Mode'),
        content: SizedBox(
          width: 340,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.person, color: isTeam ? CandelaColors.textMuted : CandelaColors.accent),
                title: const Text('Solo / Dev Mode'),
                subtitle: const Text('Local only — no remote server', style: TextStyle(fontSize: 12)),
                selected: !isTeam,
                selectedTileColor: CandelaColors.accentDim,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                onTap: () {
                  Navigator.of(ctx).pop();
                  if (isTeam) {
                    _confirmSwitchToSolo(context);
                  } else {
                    onSwitchToSolo?.call();
                  }
                },
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: Icon(Icons.groups, color: isTeam ? CandelaColors.success : CandelaColors.textMuted),
                title: const Text('Team Mode'),
                subtitle: Text(
                  isTeam ? 'Current: ${config.remote}' : 'Connect to a remote Candela server',
                  style: const TextStyle(fontSize: 12),
                ),
                selected: isTeam,
                selectedTileColor: CandelaColors.success.withValues(alpha: 0.1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                onTap: () {
                  Navigator.of(ctx).pop();
                  _showTeamUrlDialog(context);
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
        ],
      ),
    );
  }

  void _showTeamUrlDialog(BuildContext context) {
    final controller = TextEditingController(text: config.remote ?? 'https://');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: CandelaColors.bgSecondary,
        title: const Text('Team Mode — Server URL'),
        content: SizedBox(
          width: 340,
          child: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Remote URL',
              hintText: 'https://candela.example.com',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final url = controller.text.trim();
              Navigator.of(ctx).pop();
              if (url.isNotEmpty && url != 'https://') {
                onSwitchToTeam?.call(url);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _confirmSwitchToSolo(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: CandelaColors.bgSecondary,
        title: const Text('Switch to Solo Mode?'),
        content: SizedBox(
          width: 340,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('This will disconnect from the team server:'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: CandelaColors.bgTertiary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(config.remote ?? '', style: const TextStyle(fontSize: 12, fontFamily: 'SF Mono, monospace')),
              ),
              const SizedBox(height: 12),
              const Row(children: [
                Icon(Icons.warning_amber, size: 14, color: CandelaColors.warning),
                SizedBox(width: 6),
                Expanded(child: Text('Traces and cost data will not be sent to the team dashboard.',
                  style: TextStyle(fontSize: 12, color: CandelaColors.warning))),
              ]),
              const SizedBox(height: 8),
              const Text('You can switch back anytime — the URL will be remembered.',
                style: TextStyle(fontSize: 12, color: CandelaColors.textSecondary)),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: CandelaColors.warning),
            onPressed: () {
              Navigator.of(ctx).pop();
              onSwitchToSolo?.call();
            },
            child: const Text('Switch to Solo'),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    return '${dt.month}/${dt.day} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

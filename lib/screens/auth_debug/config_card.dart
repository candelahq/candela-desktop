import 'dart:io';
import 'package:flutter/material.dart';
import 'package:yaml/yaml.dart';
import '../../theme/colors.dart';
import '../../models/candela_config.dart';

class ConfigCard extends StatelessWidget {
  final CandelaConfig config;
  final VoidCallback? onSwitchToSolo;
  final ValueChanged<String>? onSwitchToTeam;
  final void Function(String field, int port)? onPortChanged;
  final VoidCallback? onConfigReloaded;
  const ConfigCard(
      {super.key,
      required this.config,
      this.onSwitchToSolo,
      this.onSwitchToTeam,
      this.onPortChanged,
      this.onConfigReloaded});

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
                const Icon(Icons.description_outlined,
                    size: 18, color: CandelaColors.textSecondary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(config.path,
                      style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'SF Mono, monospace',
                          color: CandelaColors.textSecondary)),
                ),
                if (config.lastModified != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(_formatTime(config.lastModified!),
                        style: const TextStyle(
                            fontSize: 11, color: CandelaColors.textMuted)),
                  ),
                Tooltip(
                  message: 'Edit raw YAML config',
                  child: InkWell(
                    borderRadius: BorderRadius.circular(4),
                    onTap: () => _showYamlEditor(context),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: CandelaColors.bgTertiary,
                      ),
                      child: const Icon(Icons.edit_note,
                          size: 16, color: CandelaColors.textMuted),
                    ),
                  ),
                ),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: modeColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(100),
                        border:
                            Border.all(color: modeColor.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(modeLabel,
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: modeColor)),
                          const SizedBox(width: 4),
                          Icon(Icons.swap_horiz, size: 12, color: modeColor),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                if (config.remote != null)
                  Expanded(
                      child: Text(
                    config.remote!,
                    style: const TextStyle(
                        fontSize: 11, color: CandelaColors.textSecondary),
                    overflow: TextOverflow.ellipsis,
                  )),
                if (config.providers.isNotEmpty && config.remote == null)
                  Text(
                    'Providers: ${config.providers.map((p) => p.name).join(", ")}',
                    style: const TextStyle(
                        fontSize: 12, color: CandelaColors.textSecondary),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            // Listener ports
            Wrap(
              spacing: 12,
              runSpacing: 6,
              children: [
                _portChip(context, 'API', 'port', config.port,
                    'OpenAI-compatible API endpoint'),
                _portChip(context, 'IDE', 'lmstudio_port', config.lmStudioPort,
                    'OpenAI-compatible IDE endpoint'),
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
                        issue.severity == IssueSeverity.error
                            ? Icons.error_outline
                            : issue.severity == IssueSeverity.warning
                                ? Icons.warning_amber_outlined
                                : Icons.info_outline,
                        size: 14,
                        color: issue.severity == IssueSeverity.error
                            ? CandelaColors.error
                            : issue.severity == IssueSeverity.warning
                                ? CandelaColors.warning
                                : CandelaColors.info,
                      ),
                      const SizedBox(width: 6),
                      Text(issue.message,
                          style: TextStyle(
                            fontSize: 12,
                            color: issue.severity == IssueSeverity.error
                                ? CandelaColors.error
                                : issue.severity == IssueSeverity.warning
                                    ? CandelaColors.warning
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
                leading: Icon(Icons.person,
                    color: isTeam
                        ? CandelaColors.textMuted
                        : CandelaColors.accent),
                title: const Text('Solo / Dev Mode'),
                subtitle: const Text('Local only — no remote server',
                    style: TextStyle(fontSize: 12)),
                selected: !isTeam,
                selectedTileColor: CandelaColors.accentDim,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
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
                leading: Icon(Icons.groups,
                    color: isTeam
                        ? CandelaColors.success
                        : CandelaColors.textMuted),
                title: const Text('Team Mode'),
                subtitle: Text(
                  isTeam
                      ? 'Current: ${config.remote}'
                      : 'Connect to a remote Candela server',
                  style: const TextStyle(fontSize: 12),
                ),
                selected: isTeam,
                selectedTileColor: CandelaColors.success.withValues(alpha: 0.1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                onTap: () {
                  Navigator.of(ctx).pop();
                  _showTeamUrlDialog(context);
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel')),
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
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel')),
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
                child: Text(config.remote ?? '',
                    style: const TextStyle(
                        fontSize: 12, fontFamily: 'SF Mono, monospace')),
              ),
              const SizedBox(height: 12),
              const Row(children: [
                Icon(Icons.warning_amber,
                    size: 14, color: CandelaColors.warning),
                SizedBox(width: 6),
                Expanded(
                    child: Text(
                        'Traces and cost data will not be sent to the team dashboard.',
                        style: TextStyle(
                            fontSize: 12, color: CandelaColors.warning))),
              ]),
              const SizedBox(height: 8),
              const Text(
                  'You can switch back anytime — the URL will be remembered.',
                  style: TextStyle(
                      fontSize: 12, color: CandelaColors.textSecondary)),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: CandelaColors.warning),
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

  Widget _portChip(BuildContext context, String label, String field, int port,
      String tooltip) {
    return Tooltip(
      message: '$tooltip\nlocalhost:$port\nClick to edit',
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: onPortChanged != null
            ? () => _showPortEditor(context, label, field, port)
            : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: CandelaColors.bgTertiary,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: CandelaColors.borderSubtle),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                label == 'API' ? Icons.cloud_outlined : Icons.terminal,
                size: 12,
                color: CandelaColors.textMuted,
              ),
              const SizedBox(width: 4),
              Text('$label :$port',
                  style: const TextStyle(
                      fontSize: 11,
                      fontFamily: 'SF Mono, monospace',
                      color: CandelaColors.textSecondary)),
              if (onPortChanged != null) ...[
                const SizedBox(width: 4),
                const Icon(Icons.edit,
                    size: 10, color: CandelaColors.textMuted),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showPortEditor(
      BuildContext context, String label, String field, int currentPort) {
    final controller = TextEditingController(text: '$currentPort');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: CandelaColors.bgSecondary,
        title: Text('Edit $label Port'),
        content: SizedBox(
          width: 240,
          child: TextField(
            controller: controller,
            autofocus: true,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Port',
              hintText: '$currentPort',
              border: const OutlineInputBorder(),
              helperText: field == 'port'
                  ? 'OpenAI-compatible API endpoint'
                  : 'OpenAI-compatible IDE endpoint',
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final port = int.tryParse(controller.text.trim());
              if (port != null && port > 0 && port <= 65535) {
                Navigator.of(ctx).pop();
                onPortChanged?.call(field, port);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showYamlEditor(BuildContext context) async {
    final file = File(config.path);
    String content = '';
    if (await file.exists()) {
      content = await file.readAsString();
    }

    final controller = TextEditingController(text: content);
    String? errorText;

    if (!context.mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: CandelaColors.bgSecondary,
          title: Row(
            children: [
              const Icon(Icons.edit_note, size: 20),
              const SizedBox(width: 8),
              const Text('Edit Config'),
              const Spacer(),
              Text(config.path.split('/').last,
                  style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'SF Mono, monospace',
                      color: CandelaColors.textMuted)),
            ],
          ),
          content: SizedBox(
            width: 520,
            height: 400,
            child: Column(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    maxLines: null,
                    expands: true,
                    style: const TextStyle(
                        fontSize: 13,
                        fontFamily: 'SF Mono, monospace',
                        height: 1.5),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: CandelaColors.bgTertiary,
                      errorText: errorText,
                      hintText:
                          '# ~/.candela.yaml\nport: 8181\nproviders:\n  - name: google',
                      hintStyle: TextStyle(
                          color:
                              CandelaColors.textMuted.withValues(alpha: 0.5)),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Row(
                  children: [
                    Icon(Icons.info_outline,
                        size: 12, color: CandelaColors.textMuted),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                          'Changes are written directly to disk. The app will reload automatically.',
                          style: TextStyle(
                              fontSize: 11, color: CandelaColors.textMuted)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.save, size: 16),
              onPressed: () async {
                final text = controller.text;
                try {
                  // Validate YAML before writing.
                  if (text.trim().isNotEmpty) {
                    loadYaml(text); // throws YamlException on bad syntax
                  }
                  await file.writeAsString(text);
                  if (ctx.mounted) Navigator.of(ctx).pop();
                  onConfigReloaded?.call();
                } on YamlException catch (e) {
                  setDialogState(
                      () => errorText = 'Invalid YAML: ${e.message}');
                } catch (e) {
                  setDialogState(() => errorText = 'Write failed: $e');
                }
              },
              label: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    return '${dt.month}/${dt.day} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

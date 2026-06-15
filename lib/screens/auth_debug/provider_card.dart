import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import '../../theme/colors.dart';
import '../../models/provider_status.dart';
import '../../services/provider_test_service.dart';

class ProviderCard extends StatelessWidget {
  final ProviderStatus status;
  final VoidCallback? onRemove;
  const ProviderCard({super.key, required this.status, this.onRemove});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: status.models.isNotEmpty ? () => _showDetailDialog(context) : null,
      child: Container(
        decoration: BoxDecoration(
          color: CandelaColors.bgSecondary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _borderColor),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _header(),
          const SizedBox(height: 8),
          if (status.state == ProviderState.loading)
            const Expanded(
                child: Center(
                    child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: CandelaColors.accent))))
          else ...[
            if (status.project != null) _row('Project', status.project!),
            if (status.region != null) _row('Region', status.region!),
            if (status.models.isNotEmpty)
              Row(children: [
                Expanded(
                    child: Text(
                  'Models: ${status.models.take(3).join(", ")}',
                  style: const TextStyle(
                      fontSize: 11, color: CandelaColors.textSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )),
                if (status.models.length > 3)
                  Text(' +${status.models.length - 3}',
                      style: const TextStyle(
                          fontSize: 10, color: CandelaColors.textMuted)),
              ]),
            if (status.errorDetail != null)
              Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(children: [
                    const Icon(Icons.warning_amber,
                        size: 12, color: CandelaColors.warning),
                    const SizedBox(width: 4),
                    Flexible(
                        child: Text(status.errorDetail!,
                            style: const TextStyle(
                                fontSize: 11, color: CandelaColors.warning),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis)),
                  ])),
            const Spacer(),
            _action(context),
          ],
        ]),
      ),
    );
  }

  void _showDetailDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => _ProviderDetailDialog(status: status),
    );
  }

  Color get _borderColor => switch (status.state) {
        ProviderState.connected => CandelaColors.success.withValues(alpha: 0.3),
        ProviderState.error => CandelaColors.error.withValues(alpha: 0.3),
        _ => CandelaColors.borderSubtle,
      };

  Widget _header() {
    final color = switch (status.state) {
      ProviderState.connected => CandelaColors.success,
      ProviderState.error => CandelaColors.error,
      _ => CandelaColors.textMuted,
    };
    return Row(children: [
      Text(status.icon ?? '', style: const TextStyle(fontSize: 16)),
      const SizedBox(width: 8),
      Expanded(
          child: Text(status.displayName,
              style:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
      Text(status.statusMessage ?? '',
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.w500, color: color)),
      if (onRemove != null) ...[
        const SizedBox(width: 6),
        Tooltip(
          message: 'Remove from config',
          child: InkWell(
            borderRadius: BorderRadius.circular(4),
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: CandelaColors.bgTertiary,
              ),
              child: const Icon(Icons.close,
                  size: 12, color: CandelaColors.textMuted),
            ),
          ),
        ),
      ],
    ]);
  }

  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: Text('$label: $value',
            style: const TextStyle(
                fontSize: 11, color: CandelaColors.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
      );

  Widget _action(BuildContext context) {
    if (status.fixUrl != null) {
      return Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
              onPressed: () => launchUrl(Uri.parse(status.fixUrl!)),
              child: const Text('Fix →')));
    }
    if (status.fixCommand != null) {
      return Align(
          alignment: Alignment.centerRight,
          child: OutlinedButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: status.fixCommand!));
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Copied: ${status.fixCommand}')));
              },
              icon: const Icon(Icons.copy, size: 14),
              label: Text(status.fixCommand!,
                  style:
                      const TextStyle(fontSize: 11, fontFamily: 'monospace'))));
    }
    return const SizedBox.shrink();
  }
}

// ---------------------------------------------------------------------------
// Detail dialog — auto-verifies proxy models on open.
// ---------------------------------------------------------------------------

class _ProviderDetailDialog extends StatefulWidget {
  final ProviderStatus status;
  const _ProviderDetailDialog({required this.status});
  @override
  State<_ProviderDetailDialog> createState() => _ProviderDetailDialogState();
}

class _ProviderDetailDialogState extends State<_ProviderDetailDialog> {
  final _providerTest = ProviderTestService();
  Map<String, ModelVerification?> _verifications = {};
  bool _verifying = false;

  @override
  void initState() {
    super.initState();
    if (widget.status.name == 'proxy' && widget.status.models.isNotEmpty) {
      _verifyAll();
    }
  }

  Future<void> _verifyAll() async {
    final displayModels = widget.status.models;
    final rawModels = widget.status.rawModels;

    setState(() {
      _verifying = true;
      _verifications = {for (final m in displayModels) m: null};
    });

    final raw = rawModels.isNotEmpty ? rawModels : displayModels;

    final results = await _providerTest.verifyProxyModels(
      raw,
      port: widget.status.port ?? 8181,
    );

    if (!mounted) return;

    final rawResults = {for (final r in results) r.model: r};

    setState(() {
      _verifying = false;
      for (var i = 0; i < displayModels.length; i++) {
        final rawName = i < raw.length ? raw[i] : displayModels[i];
        final r = rawResults[rawName];
        _verifications[displayModels[i]] = ModelVerification(
            model: displayModels[i],
            reachable: r?.reachable ?? false,
            latency: r?.latency,
            error: r == null ? 'No verification result' : r.error);
      }
    });
  }

  @override
  void dispose() {
    _providerTest.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.status;
    return AlertDialog(
      backgroundColor: CandelaColors.bgSecondary,
      title: Row(children: [
        Text(s.icon ?? '', style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 8),
        Text(s.displayName),
        const Spacer(),
        if (s.name == 'proxy')
          TextButton.icon(
            onPressed: _verifying ? null : _verifyAll,
            icon: Icon(_verifying ? Icons.hourglass_top : Icons.verified,
                size: 14),
            label: Text(_verifying ? 'Verifying...' : 'Re-verify'),
          ),
      ]),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (s.project != null) _infoRow('Project', s.project!),
            if (s.region != null) _infoRow('Region', s.region!),
            if (s.latency != null)
              _infoRow('Latency', '${s.latency!.inMilliseconds}ms'),
            const SizedBox(height: 12),
            Row(children: [
              const Text('Available Models',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              const Spacer(),
              Text('${s.models.length} models',
                  style: const TextStyle(
                      fontSize: 11, color: CandelaColors.textMuted)),
            ]),
            const SizedBox(height: 8),
            ...s.models.map((m) => _modelRow(m)),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close')),
      ],
    );
  }

  Widget _modelRow(String model) {
    final v = _verifications[model];
    final Widget indicator;
    if (v == null && _verifications.containsKey(model)) {
      indicator = const SizedBox(
          width: 12,
          height: 12,
          child: CircularProgressIndicator(
              strokeWidth: 1.5, color: CandelaColors.accent));
    } else if (v != null) {
      indicator = Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: v.reachable ? CandelaColors.success : CandelaColors.error),
      );
    } else {
      indicator = Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: CandelaColors.success.withValues(alpha: 0.4)),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(children: [
        indicator,
        const SizedBox(width: 10),
        Expanded(
            child: Text(model,
                style: const TextStyle(
                    fontSize: 12, fontFamily: 'SF Mono, monospace'))),
        if (v?.latency != null)
          Text('${v!.latency!.inMilliseconds}ms',
              style: const TextStyle(
                  fontSize: 10, color: CandelaColors.textMuted)),
        if (v != null && !v.reachable && v.error != null)
          Tooltip(
            message: v.error,
            child: const Padding(
              padding: EdgeInsets.only(left: 4),
              child: Icon(Icons.warning_amber,
                  size: 12, color: CandelaColors.error),
            ),
          ),
      ]),
    );
  }

  Widget _infoRow(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(children: [
          Text('$label: ',
              style: const TextStyle(
                  fontSize: 12, color: CandelaColors.textMuted)),
          Text(value, style: const TextStyle(fontSize: 12)),
        ]),
      );
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../theme/colors.dart';

/// Embeds the Next.js web dashboard's /search page in a native WebView.
///
/// This avoids duplicating the search UI in Dart by reusing the web
/// implementation. The WebView points at the local Candela server's
/// dashboard (default: http://localhost:8181/search).
class SearchWebViewScreen extends StatefulWidget {
  final int port;

  const SearchWebViewScreen({super.key, this.port = 8181});

  @override
  State<SearchWebViewScreen> createState() => _SearchWebViewScreenState();
}

class _SearchWebViewScreenState extends State<SearchWebViewScreen> {
  WebViewController? _controller;
  bool _isLoading = true;
  String? _error;
  bool _platformSupported = false;

  @override
  void initState() {
    super.initState();
    _platformSupported = Platform.isMacOS || Platform.isIOS;
    if (!_platformSupported) return;

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(CandelaColors.bgPrimary)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (mounted) setState(() => _isLoading = true);
          },
          onPageFinished: (_) {
            if (mounted) setState(() => _isLoading = false);
          },
          onWebResourceError: (error) {
            if (error.isForMainFrame != true) return;
            if (mounted) {
              setState(() {
                _isLoading = false;
                _error = error.description;
              });
            }
          },
        ),
      )
      ..loadRequest(Uri.parse('http://127.0.0.1:${widget.port}/spans'));
  }

  @override
  Widget build(BuildContext context) {
    if (!_platformSupported) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.desktop_access_disabled,
                size: 48,
                color: CandelaColors.textMuted,
              ),
              SizedBox(height: 16),
              Text(
                'Search WebView is not available on this platform.',
                style: TextStyle(
                  fontSize: 14,
                  color: CandelaColors.textSecondary,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Open the Candela dashboard in your browser instead.',
                style: TextStyle(fontSize: 13, color: CandelaColors.textMuted),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        // Header bar matching the native app style
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: const BoxDecoration(
            color: CandelaColors.bgSecondary,
            border: Border(
              bottom: BorderSide(color: CandelaColors.borderSubtle),
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, size: 18, color: CandelaColors.accent),
              const SizedBox(width: 10),
              const Text(
                'Search Spans',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: CandelaColors.textPrimary,
                ),
              ),
              const Spacer(),
              if (_isLoading)
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: CandelaColors.accent,
                  ),
                ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(
                  Icons.refresh,
                  size: 18,
                  color: CandelaColors.textSecondary,
                ),
                tooltip: 'Reload',
                onPressed: () {
                  setState(() {
                    _error = null;
                    _isLoading = true;
                  });
                  _controller!.reload();
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.open_in_browser,
                  size: 18,
                  color: CandelaColors.textSecondary,
                ),
                tooltip: 'Open in browser',
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  final url = await _controller!.currentUrl();
                  if (url != null) {
                    final uri = Uri.parse(url);
                    if (!await launchUrl(
                      uri,
                      mode: LaunchMode.externalApplication,
                    )) {
                      if (mounted) {
                        messenger.showSnackBar(
                          const SnackBar(
                            content: Text('Could not open browser'),
                          ),
                        );
                      }
                    }
                  }
                },
              ),
            ],
          ),
        ),
        // WebView content
        Expanded(
          child: _error != null
              ? _buildErrorState()
              : WebViewWidget(controller: _controller!),
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off,
              size: 48,
              color: CandelaColors.textMuted,
            ),
            const SizedBox(height: 16),
            const Text(
              'Dashboard not available',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: CandelaColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Could not load the search page. Make sure the Candela dashboard is running.\n\n$_error',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: CandelaColors.textMuted,
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: CandelaColors.accent,
              ),
              onPressed: () {
                setState(() {
                  _error = null;
                  _isLoading = true;
                });
                _controller!.reload();
              },
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

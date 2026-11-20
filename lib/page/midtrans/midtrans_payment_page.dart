import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_foodstore/core/constants/app_config.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MidtransPaymentPage extends StatefulWidget {
  final String snapToken;
  const MidtransPaymentPage({super.key, required this.snapToken});

  @override
  State<MidtransPaymentPage> createState() => _MidtransPaymentPageState();
}

class _MidtransPaymentPageState extends State<MidtransPaymentPage> {
  WebViewController? _webViewController;

  String get _paymentUrl => AppConfig.URL_PAYMENT + widget.snapToken;

  @override
  void initState() {
    super.initState();
    // WebView tidak didukung di web (Chrome), jadi hanya dibuat di Android/iOS
    if (kIsWeb) return;

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (url) {
          // Cek jika URL adalah sukses atau gagal, lakukan sesuatu
          if (url.contains('/success')) {
            context.pop('success');
          } else if (url.contains('/failure')) {
            context.pop('failure');
          } else if (url.contains('transaction_status=settlement')) {
            context.pop('Payment Success');
          } else if (url.contains('transaction_status=expire')) {
            context.pop('Payment Expired');
          } else if (url.contains('transaction_status=cancel')) {
            context.pop('Payment Canceled');
          } else if (url.contains('transaction_status=deny')) {
            context.pop('Payment Denied');
          }
        },
      ))
      ..loadRequest(Uri.parse(_paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
        title: const Text(
          'Midtrans Payment',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: kIsWeb
          ? _buildWebFallback()
          : WebViewWidget(controller: _webViewController!),
    );
  }

  /// Tampilan untuk Chrome: buka halaman pembayaran di tab baru
  Widget _buildWebFallback() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.payment_rounded, size: 64),
            const SizedBox(height: 16),
            const Text(
              'Pembayaran dibuka di tab baru karena WebView tidak '
              'didukung di browser.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () async {
                await launchUrl(
                  Uri.parse(_paymentUrl),
                  mode: LaunchMode.externalApplication,
                );
              },
              child: const Text(
                'Buka Halaman Pembayaran',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
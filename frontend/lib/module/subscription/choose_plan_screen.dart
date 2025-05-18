import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app_links/app_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:frontend/services/storage_service.dart';
import 'package:frontend/module/subscription/success__page.dart';

class ChoosePlanScreen extends StatefulWidget {
  const ChoosePlanScreen({Key? key}) : super(key: key);

  @override
  State<ChoosePlanScreen> createState() => _ChoosePlanScreenState();
}

class _ChoosePlanScreenState extends State<ChoosePlanScreen> {
  String _selectedPlan = 'basic-plan';
  bool _loading = false;
  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _sub;
  bool _hasHandledInitialLink = false;

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();
    _listenToLinks();
    _checkInitialLink();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  Future<String?> _getToken() async {
    return await StorageService().getAccessToken();
  }

  void _listenToLinks() {
    _sub = _appLinks.uriLinkStream.listen((uri) {
      _handleUri(uri);
    }, onError: (err) {
      print("Link stream error: $err");
    });
  }

  Future<void> _checkInitialLink() async {
    try {
      final uri = await _appLinks.getInitialAppLink();
      if (uri != null) {
        _handleUri(uri);
      }
    } catch (e) {
      print("Initial link error: $e");
    }
  }

  void _handleUri(Uri uri) async {

  if (uri.scheme == 'myapp' &&
      uri.host == 'subscription' &&
      uri.path == '/success') {
    final subscriptionId = uri.queryParameters['subscription_id'];
    if (subscriptionId != null) {
      final alreadyHandled = await StorageService().hasHandledSubscriptionSuccess(subscriptionId);
      if (alreadyHandled) return;
      final status = await _checkSubscriptionStatus(subscriptionId);
      if (status == 'ACTIVE') {
        await StorageService().setHandledSubscriptionSuccess(subscriptionId);
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SuccessPage()),
        );
      } else {
        _showDialog("Subscription status: $status");
      }
    }
  }
}



  Future<String?> _checkSubscriptionStatus(String subscriptionId) async {
    final uri = Uri.parse("https://a85a-117-2-255-218.ngrok-free.app/api/v1/subscription/$subscriptionId");
    final token = await _getToken();

    try {
      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['result'];
      } else {
        print("Backend error: ${response.body}");
      }
    } catch (e) {
      print("Error checking status: $e");
    }

    return null;
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Notification"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<void> _subscribeToPlan(String planId) async {
    setState(() => _loading = true);

    final token = await _getToken();
    final userId = await StorageService().getUserInfo();
    if (token == null) {
      _showDialog("Authentication token not found. Please log in again.");
      setState(() => _loading = false);
      return;
    }

    final uri = Uri.parse("https://a85a-117-2-255-218.ngrok-free.app/api/v1/subscription");

    try {
      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "plan_id": planId,
          "account_id": userId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final links = data['result']['links'] ?? [];

        final approvalLink = links.firstWhere(
          (link) => link['rel'] == 'approve',
          orElse: () => null,
        );

        final String? approvalUrl = approvalLink?['href'];

        if (approvalUrl != null) {
          await launchUrl(Uri.parse(approvalUrl), mode: LaunchMode.externalApplication);
        } else {
          _showDialog("Approval link not found.");
        }
      } else {
        _showDialog("Error ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      _showDialog("Something went wrong: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade300),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard({
    required String id,
    required String title,
    required String price,
    required Color borderColor,
    required List<Map<String, dynamic>> features,
    required bool selected,
  }) {
    final isDisabled = id == 'basic-plan';

    return GestureDetector(
      onTap: isDisabled
          ? null
          : () {
              setState(() {
                _selectedPlan = id;
              });
            },
      child: Opacity(
        opacity: isDisabled ? 0.5 : 1.0,
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: selected ? borderColor.withOpacity(0.1) : Colors.grey.shade900,
            border: Border.all(
              color: selected ? borderColor : Colors.grey.shade800,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 10),
              Text(price, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 12),
              ...features.map((f) => _buildFeatureRow(f['icon'], f['text'])).toList(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final plans = [
      {
        "id": "basic-plan",
        "title": "BASIC Plan",
        "price": "Free forever",
        "color": Colors.green,
        "features": [
          {"icon": Icons.person, "text": "Up to 3 profiles"},
          {"icon": Icons.devices, "text": "1 device at a time"},
          {"icon": Icons.lock_open, "text": "100% free, no hidden fees"},
        ],
      },
      {
        "id": "P-0RC42556JN976351LM7Z5LEY",
        "title": "STANDARD Plan",
        "price": "\$16.50 / month",
        "color": Colors.blue,
        "features": [
          {"icon": Icons.person_outline, "text": "Up to 4 profiles"},
          {"icon": Icons.devices_other, "text": "Stream on 2 devices"},
          {"icon": Icons.high_quality, "text": "Great video quality"},
        ],
      },
      {
        "id": "P-5FH19173XA7256423M7Z5MMI",
        "title": "PREMIUM Plan",
        "price": "\$22.00 / month",
        "color": Colors.red,
        "features": [
          {"icon": Icons.person_add_alt, "text": "Up to 5 profiles"},
          {"icon": Icons.tv, "text": "Watch on 4 devices"},
          {"icon": Icons.star, "text": "Best video quality"},
        ],
      },
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Choose your plan', style: TextStyle(fontSize: 16, color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Choose the plan that’s right for you',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            Text(
              'Unlimited viewing. No ads.\nTailored recommendations.\nCancel or switch plans anytime.',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade400, height: 1.5),
            ),
            const SizedBox(height: 20),
            ...plans.map((plan) => _buildPlanCard(
                  id: plan['id'] as String,
                  title: plan['title'] as String,
                  price: plan['price'] as String,
                  borderColor: plan['color'] as Color,
                  features: plan['features'] as List<Map<String, dynamic>>,
                  selected: _selectedPlan == plan['id'],
                )),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _loading ? null : () => _subscribeToPlan(_selectedPlan),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: _loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Center(
                      child: Text(
                        'SUBSCRIBE',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}



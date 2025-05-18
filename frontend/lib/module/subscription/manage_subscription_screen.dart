import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/module/subscription/choose_plan_screen.dart';
import 'package:frontend/services/storage_service.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/repositories/subscription_repository.dart';
import 'package:frontend/module/notify/screens/error-notify.dart';
import 'package:frontend/module/notify/screens/success-notify.dart';
import 'package:frontend/module/subscription/success_cancel_page.dart';

class ManageSubscriptionScreen extends ConsumerStatefulWidget {
  const ManageSubscriptionScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ManageSubscriptionScreen> createState() => _ManageSubscriptionScreenState();
}

class _ManageSubscriptionScreenState extends ConsumerState<ManageSubscriptionScreen> {
  Map<String, dynamic>? currentPlan;

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

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> cancelSubscription() async {
    final accountId = await StorageService().getUserInfo();
    if (accountId == null) {
      print('Account ID is null');
      showErrorNotify(context, "Error", "Account ID not found");
      return;
    }
    try {
      print('Canceling subscription for account: $accountId');
      final apiService = ref.read(apiServiceProvider);
      final subscriptionRepository = SubscriptionRepository(apiService);
      final success = await subscriptionRepository.cancelSubscription(accountId);
      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const CancelPlanPage()),
        );
        await _fetchUserInfo();
      } else {
        showErrorNotify(context, "Error", "Failed to cancel subscription");
      }
    } catch (e) {
      print('Error in cancelSubscription: $e');
      showErrorNotify(context, "Error", "An error occurred while canceling subscription");
    }
  }

  Future<void> _fetchUserInfo() async {
    final authRepository = ref.read(authRepositoryProvider);
    final userId = await StorageService().getUserInfo();
    print('User ID: $userId');

    if (userId != null) {
      try {
        final user = await authRepository.getUserInfo(userId);
        final String userPlanId = user.currentPlan.id;

        final plan = plans.firstWhere(
          (p) => p['id'] == userPlanId,
          orElse: () => plans[0],
        );
        // print("User plan ID: $userPlanId");
        // print("User plan: $plan");
        setState(() {
          currentPlan = plan;
        });
      } catch (e) {
        print('Error fetching user info: $e');
      }
    } else {
      print('User ID not found.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Manage Subscription',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: currentPlan == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Current Plan Display
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                currentPlan!['title'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade400,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Text(
                                  'Active',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ...List<Widget>.from(currentPlan!['features'].map(
                            (feature) => Row(
                              children: [
                                Icon(feature['icon'], color: Colors.grey),
                                const SizedBox(width: 8),
                                Text(
                                  feature['text'],
                                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                                ),
                              ],
                            ),
                          )),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text('Next billing date:',
                                  style: TextStyle(color: Colors.grey, fontSize: 16)),
                              Text('10/8/2025',
                                  style: TextStyle(color: Colors.white70, fontSize: 16)),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const ChoosePlanScreen(),
                                      ),
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Colors.white),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                  child: const Text(
                                    'CHANGE PLAN',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    cancelSubscription();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                  child: const Text(
                                    'CANCEL',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

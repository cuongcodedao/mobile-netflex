// Remove Riverpod provider from here, use direct instantiation in screen
import 'package:frontend/services/api_services.dart';
import 'package:frontend/services/storage_service.dart';

class SubscriptionRepository {
  final ApiService apiService;

  SubscriptionRepository(this.apiService);

  Future<bool> cancelSubscription(int accountId) async {
    String? accessToken = await StorageService().getAccessToken();
    if (accessToken == null) return false;

    try {
      final response = await apiService.delete(
        '/api/v1/subscription/cancel/account/$accountId',
        token: accessToken,
      );
      print('Cancel subscription response: ${response.data}');
      return response.statusCode == 200;
    } catch (e) {
      print('Error canceling subscription: $e');
      return false;
    }
  }
} 
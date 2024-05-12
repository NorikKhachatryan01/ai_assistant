import 'package:flutter_riverpod/flutter_riverpod.dart';

final subscriptionProvider = StateNotifierProvider<SubscriptionNotifier, bool>((ref) {
  return SubscriptionNotifier();
});

class SubscriptionNotifier extends StateNotifier<bool> {
  SubscriptionNotifier() : super(false); 

 
  bool get isSubscribed => state;

 
  void updateSubscription(bool isSubscribed) {
    state = isSubscribed;
  }
}
class SubscriptionModel {
  final String? id;
  final String? userId;
  final String plan;
  final String status;
  final String? platform;
  final String? environment;
  final String? productId;
  final bool? autoRenewing;
  final DateTime? currentPeriodEnd;

  SubscriptionModel({
    this.id,
    this.userId,
    required this.plan,
    required this.status,
    this.platform,
    this.environment,
    this.productId,
    this.autoRenewing,
    this.currentPeriodEnd,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['_id'],
      userId: json['userId'],
      plan: json['plan'] ?? 'FREE',
      status: json['status'] ?? 'ACTIVE',
      platform: json['platform'],
      environment: json['environment'],
      productId: json['productId'],
      autoRenewing: json['autoRenewing'],
      currentPeriodEnd: json['currentPeriodEnd'] != null
          ? DateTime.tryParse(json['currentPeriodEnd'].toString())
          : null,
    );
  }

  // Returns true if the subscription status is considered active (not expired/cancelled).
  bool get isActiveStatus {
    final s = status.toUpperCase();
    return s != 'EXPIRED' &&
        s != 'CANCELLED' && // British spelling (backend)
        s != 'CANCELED' && // American spelling (Google Play API)
        s != 'INACTIVE';
  }

  // A subscription is only premium if the plan AND status are both valid.
  bool get isPremium {
    if (!isActiveStatus) return false;
    final upper = plan.toUpperCase();
    return upper == 'PREMIUM' || upper == 'ENTERPRISE';
  }

  bool get isEnterprise => isActiveStatus && plan.toUpperCase() == 'ENTERPRISE';
}

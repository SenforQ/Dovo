class VipSubscription {
  final String id;
  final String productId;
  final double price;
  final String currency;
  final String subtitle;
  final bool isMostPopular;
  final bool isPriceLoaded;

  VipSubscription({
    required this.id,
    required this.productId,
    required this.price,
    required this.currency,
    required this.subtitle,
    this.isMostPopular = false,
    this.isPriceLoaded = false,
  });

  VipSubscription copyWith({
    String? id,
    String? productId,
    double? price,
    String? currency,
    String? subtitle,
    bool? isMostPopular,
    bool? isPriceLoaded,
  }) {
    return VipSubscription(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      subtitle: subtitle ?? this.subtitle,
      isMostPopular: isMostPopular ?? this.isMostPopular,
      isPriceLoaded: isPriceLoaded ?? this.isPriceLoaded,
    );
  }
}

class VipPrivilege {
  final String title;

  VipPrivilege({
    required this.title,
  });
}

class VipSubscriptionService {
  static List<VipSubscription> getSubscriptions() {
    return [
      VipSubscription(
        id: 'weekly',
        productId: 'DovoWeekVIP',
        price: 12.99,
        currency: '\$',
        subtitle: 'per week',
        isMostPopular: false,
      ),
      VipSubscription(
        id: 'monthly',
        productId: 'DovoMonthVIP',
        price: 49.99,
        currency: '\$',
        subtitle: 'per month',
        isMostPopular: true,
      ),
    ];
  }

  static List<VipPrivilege> getPrivileges() {
    return [
      VipPrivilege(title: 'Unlock all character profiles'),
      VipPrivilege(title: 'Priority customer support'),
      VipPrivilege(title: 'Ad-free experience'),
      VipPrivilege(title: 'Exclusive VIP content'),
    ];
  }
}


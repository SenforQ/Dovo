import 'package:shared_preferences/shared_preferences.dart';

class VipService {
  static const String _kIsVipActive = 'vip.is_active';
  static const String _kVipPurchaseDate = 'vip.purchase_date';
  static const String _kVipProductId = 'vip.product_id';
  static const String _kVipExpirationDate = 'vip.expiration_date';

  /// 激活VIP
  static Future<void> activateVip({
    required String productId,
    required String purchaseDate,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // 计算过期日期
      final purchaseDateTime = DateTime.parse(purchaseDate);
      final expirationDate = productId.contains('weekly')
          ? purchaseDateTime.add(const Duration(days: 7))
          : purchaseDateTime.add(const Duration(days: 30));
      
      await prefs.setBool(_kIsVipActive, true);
      await prefs.setString(_kVipPurchaseDate, purchaseDate);
      await prefs.setString(_kVipProductId, productId);
      await prefs.setString(_kVipExpirationDate, expirationDate.toIso8601String());
    } catch (e) {
      throw Exception('Failed to activate VIP: $e');
    }
  }

  /// 停用VIP
  static Future<void> deactivateVip() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kIsVipActive, false);
      await prefs.remove(_kVipPurchaseDate);
      await prefs.remove(_kVipProductId);
      await prefs.remove(_kVipExpirationDate);
    } catch (e) {
      throw Exception('Failed to deactivate VIP: $e');
    }
  }

  /// 检查VIP是否激活
  static Future<bool> isVipActive() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_kIsVipActive) ?? false;
    } catch (e) {
      return false;
    }
  }

  /// 检查VIP是否已过期
  static Future<bool> isVipExpired() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final expirationDateStr = prefs.getString(_kVipExpirationDate);
      
      if (expirationDateStr == null) {
        return true;
      }
      
      final expirationDate = DateTime.parse(expirationDateStr);
      return DateTime.now().isAfter(expirationDate);
    } catch (e) {
      return true;
    }
  }

  /// 获取VIP剩余天数
  static Future<int> getVipRemainingDays() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final expirationDateStr = prefs.getString(_kVipExpirationDate);
      
      if (expirationDateStr == null) {
        return 0;
      }
      
      final expirationDate = DateTime.parse(expirationDateStr);
      final now = DateTime.now();
      
      if (now.isAfter(expirationDate)) {
        return 0;
      }
      
      return expirationDate.difference(now).inDays;
    } catch (e) {
      return 0;
    }
  }

  /// 获取VIP购买日期
  static Future<String?> getVipPurchaseDate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_kVipPurchaseDate);
    } catch (e) {
      return null;
    }
  }

  /// 获取VIP产品ID
  static Future<String?> getVipProductId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_kVipProductId);
    } catch (e) {
      return null;
    }
  }
}


import 'package:shared_preferences/shared_preferences.dart';

class CoinService {
  static const String _kCoinsKey = 'user.coins';

  /// 初始化新用户（只在首次进入时执行）
  /// 如果用户已有金币记录，则不做任何操作
  static Future<void> initializeNewUser() async {
    final prefs = await SharedPreferences.getInstance();
    final existingCoins = prefs.getInt(_kCoinsKey);
    
    // 如果用户还没有金币记录，初始化为 0
    if (existingCoins == null) {
      await prefs.setInt(_kCoinsKey, 0);
    }
  }

  /// 获取当前金币数量
  static Future<int> getCurrentCoins() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_kCoinsKey) ?? 0;
  }

  /// 添加金币
  /// 返回 true 表示成功，false 表示失败
  static Future<bool> addCoins(int amount) async {
    try {
      if (amount <= 0) return false;
      
      final prefs = await SharedPreferences.getInstance();
      final currentCoins = prefs.getInt(_kCoinsKey) ?? 0;
      final newCoins = currentCoins + amount;
      
      await prefs.setInt(_kCoinsKey, newCoins);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// 消费金币
  /// 返回 true 表示成功（余额足够且扣款成功），false 表示失败（余额不足或其他错误）
  static Future<bool> spendCoins(int amount) async {
    try {
      if (amount <= 0) return false;
      
      final prefs = await SharedPreferences.getInstance();
      final currentCoins = prefs.getInt(_kCoinsKey) ?? 0;
      
      if (currentCoins < amount) {
        return false; // 余额不足
      }
      
      final newCoins = currentCoins - amount;
      await prefs.setInt(_kCoinsKey, newCoins);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// 检查是否有足够的金币
  static Future<bool> hasEnoughCoins(int amount) async {
    final currentCoins = await getCurrentCoins();
    return currentCoins >= amount;
  }
}


import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';

class ATTService {
  /// 请求追踪权限
  /// 返回 true 表示用户授权，false 表示用户拒绝或未授权
  static Future<bool> requestTrackingPermission() async {
    try {
      if (!Platform.isIOS) {
        debugPrint('ATT permission is only available on iOS');
        return false;
      }

      final status = await AppTrackingTransparency.trackingAuthorizationStatus;
      debugPrint('Current ATT status: $status');

      if (status == TrackingStatus.notDetermined) {
        final newStatus = await AppTrackingTransparency.requestTrackingAuthorization();
        debugPrint('ATT permission requested, new status: $newStatus');
        return newStatus == TrackingStatus.authorized;
      }

      return status == TrackingStatus.authorized;
    } catch (e, stackTrace) {
      debugPrint('Error requesting ATT permission: $e');
      debugPrint('Stack trace: $stackTrace');
      return false;
    }
  }

  /// 检查追踪权限状态
  static Future<TrackingStatus> getTrackingStatus() async {
    try {
      if (!Platform.isIOS) {
        return TrackingStatus.restricted;
      }
      return await AppTrackingTransparency.trackingAuthorizationStatus;
    } catch (e) {
      debugPrint('Error getting ATT status: $e');
      return TrackingStatus.restricted;
    }
  }

  /// 检查是否已授权
  static Future<bool> isAuthorized() async {
    final status = await getTrackingStatus();
    return status == TrackingStatus.authorized;
  }
}



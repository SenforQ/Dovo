import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile {
  final String nickname;
  final String gender;
  final String signature;
  // store relative file name, reconstruct full path at runtime
  final String? avatarFileName;

  const UserProfile({
    required this.nickname,
    required this.gender,
    required this.signature,
    this.avatarFileName,
  });

  UserProfile copyWith({
    String? nickname,
    String? gender,
    String? signature,
    String? avatarFileName,
  }) => UserProfile(
        nickname: nickname ?? this.nickname,
        gender: gender ?? this.gender,
        signature: signature ?? this.signature,
        avatarFileName: avatarFileName ?? this.avatarFileName,
      );
}

class UserProfileManager {
  static final UserProfileManager _instance = UserProfileManager._internal();
  factory UserProfileManager() => _instance;
  UserProfileManager._internal();

  final ValueNotifier<UserProfile> notifier = ValueNotifier<UserProfile>(
    const UserProfile(nickname: 'Dovo', gender: 'Male', signature: '', avatarFileName: null),
  );

  static const _kNickname = 'profile.nickname';
  static const _kGender = 'profile.gender';
  static const _kSignature = 'profile.signature';
  static const _kAvatarFileName = 'profile.avatarFileName';
  static const _kAgreementAccepted = 'profile.agreementAccepted';

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final profile = UserProfile(
      nickname: prefs.getString(_kNickname) ?? 'Dovo',
      gender: prefs.getString(_kGender) ?? 'Male',
      signature: prefs.getString(_kSignature) ?? '',
      avatarFileName: prefs.getString(_kAvatarFileName),
    );
    notifier.value = profile;
  }

  Future<void> save(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kNickname, profile.nickname);
    await prefs.setString(_kGender, profile.gender);
    await prefs.setString(_kSignature, profile.signature);
    if (profile.avatarFileName != null) {
      await prefs.setString(_kAvatarFileName, profile.avatarFileName!);
    }
    notifier.value = profile;
  }

  String? _cachedDocsPath;

  Future<String> getDocumentsPath() async {
    if (_cachedDocsPath != null) return _cachedDocsPath!;
    final dir = await getApplicationDocumentsDirectory();
    _cachedDocsPath = dir.path;
    return _cachedDocsPath!;
  }

  Future<String> saveAvatarToSandbox(File source) async {
    final docs = await getDocumentsPath();
    final fileName = 'avatar_${DateTime.now().millisecondsSinceEpoch}${_extOf(source.path)}';
    final target = File('$docs/$fileName');
    await target.writeAsBytes(await source.readAsBytes());
    return fileName; // return relative file name
  }

  Future<String?> buildAvatarFullPath(String? fileName) async {
    if (fileName == null) return null;
    final docs = await getDocumentsPath();
    return '$docs/$fileName';
  }

  String _extOf(String path) {
    final i = path.lastIndexOf('.');
    return i >= 0 ? path.substring(i) : '';
  }

  Future<bool> hasAgreementAccepted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kAgreementAccepted) ?? false;
  }

  Future<void> setAgreementAccepted(bool accepted) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kAgreementAccepted, accepted);
  }
}



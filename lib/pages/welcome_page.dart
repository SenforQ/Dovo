import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'user_agreement_page.dart';
import 'privacy_policy_page.dart';
import '../services/user_profile.dart';
import '../services/att_service.dart';
import '../main.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool _agreedToTerms = false;
  bool _isChecking = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkAgreementStatus();
  }

  Future<void> _checkAgreementStatus() async {
    final hasAgreed = await UserProfileManager().hasAgreementAccepted();
    if (mounted) {
      if (hasAgreed) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => MainTabPage(key: MainTabPage.tabKey),
          ),
        );
      } else {
        setState(() {
          _agreedToTerms = false;
          _isChecking = false;
        });
      }
    }
  }

  Future<void> _enterApp() async {
    if (!_agreedToTerms) {
      _showAgreementRequiredDialog();
      return;
    }

    HapticFeedback.lightImpact();

    setState(() {
      _isLoading = true;
    });

    try {
      await UserProfileManager().setAgreementAccepted(true);
      
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => MainTabPage(key: MainTabPage.tabKey),
          ),
        );
      }
      
      _requestTrackingPermissionInBackground();
    } catch (e) {
      debugPrint('进入应用失败: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog();
      }
    }
  }

  Future<void> _requestTrackingPermissionInBackground() async {
    try {
      debugPrint('Requesting ATT permission in background...');
      final isAuthorized = await ATTService.requestTrackingPermission();
      debugPrint('ATT permission result: $isAuthorized');
    } catch (e, stackTrace) {
      debugPrint('Background ATT request failed: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  void _showAgreementRequiredDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1C0325),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.orange,
                  size: 30,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Agreement Required',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Please agree to the Terms of Service and Privacy Policy before entering the app.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE91E63),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 8,
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1C0325),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 30,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Error',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Failed to enter the app. Please try again.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE91E63),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 8,
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final size = MediaQuery.of(context).size;
    final double scale = size.height / 812.0;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/welcome_bg.webp'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Spacer(),
              Container(
                width: 200 * scale,
                height: 50 * scale,
                decoration: BoxDecoration(
                  color: _agreedToTerms && !_isLoading
                      ? Colors.white.withOpacity(0.9)
                      : Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(25 * scale),
                  boxShadow: _agreedToTerms && !_isLoading
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _isLoading ? null : _enterApp,
                    borderRadius: BorderRadius.circular(25 * scale),
                    child: Center(
                      child: _isLoading
                          ? SizedBox(
                              width: 24 * scale,
                              height: 24 * scale,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                              ),
                            )
                          : Text(
                              'Enter App',
                              style: TextStyle(
                                fontSize: 18 * scale,
                                fontWeight: FontWeight.w600,
                                color: _agreedToTerms ? Colors.black : Colors.black54,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24 * scale),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40 * scale),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _agreedToTerms = !_agreedToTerms;
                        });
                      },
                      child: Container(
                        width: 20 * scale,
                        height: 20 * scale,
                        decoration: BoxDecoration(
                          color: _agreedToTerms
                              ? Colors.white
                              : Colors.transparent,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: _agreedToTerms
                            ? Icon(
                                Icons.check,
                                size: 16 * scale,
                                color: Colors.black,
                              )
                            : null,
                      ),
                    ),
                    SizedBox(width: 12 * scale),
                    Expanded(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            'I have read and agree ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14 * scale,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const UserAgreementPage(),
                                ),
                              );
                            },
                            child: Text(
                              'Terms of Service',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14 * scale,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            ' and ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14 * scale,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const PrivacyPolicyPage(),
                                ),
                              );
                            },
                            child: Text(
                              'Privacy Policy',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14 * scale,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40 * scale),
            ],
          ),
        ),
      ),
    );
  }
}


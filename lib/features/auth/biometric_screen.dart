import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../routes/app_routes.dart';

class BiometricScreen extends StatefulWidget {
  final VoidCallback onSuccess;
  const BiometricScreen({required this.onSuccess, super.key});

  @override
  State<BiometricScreen> createState() => _BiometricScreenState();
}

class _BiometricScreenState extends State<BiometricScreen> {
  final LocalAuthentication auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    authenticateUser();
  }

  Future<void> authenticateUser() async {
    try {
      // Skip biometric on web
      if (kIsWeb) {
        widget.onSuccess();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          }
        });
        return;
      }

      bool canCheck = await auth.canCheckBiometrics;
      if (!canCheck) {
        if (mounted) {
          widget.onSuccess();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              Navigator.pushReplacementNamed(context, AppRoutes.home);
            }
          });
        }
        return;
      }

      bool authenticated = await auth.authenticate(
        localizedReason: 'Scan your finger to proceed',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (authenticated && mounted) {
        widget.onSuccess();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                Navigator.pushReplacementNamed(context, AppRoutes.home);
              }
            });
          }
        });
      }
    } catch (e) {
      debugPrint('Biometric error: $e');

      if (mounted) {
        widget.onSuccess();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                Navigator.pushReplacementNamed(context, AppRoutes.home);
              }
            });
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Center(
                child: Icon(
                  Icons.fingerprint,
                  size: 100.w,
                  color: Colors.white54,
                ),
              ),
              SizedBox(height: 40.h),
              Text(
                'LOGIN BIOMETRIC',
                style: TextStyle(
                  fontSize: 24.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Please authenticate to continue',
                style: TextStyle(color: Colors.white70, fontSize: 16.sp),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              TextButton(
                onPressed: authenticateUser,
                child: Text(
                  'Try Again',
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}

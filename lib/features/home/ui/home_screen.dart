import 'package:beatbox/features/home/ui/home_mobile_view.dart';
import 'package:beatbox/features/home/ui/home_web_view.dart';
import 'package:flutter/material.dart';
import 'package:beatbox/utils/responsive_utils.dart';
import 'package:beatbox/features/app_settings_info_management/controller/theme_controller.dart';

class HomeScreen extends StatefulWidget {
  final int selectedIndex;
  const HomeScreen({super.key, this.selectedIndex = 0});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: ThemeController.isDarkMode,
      builder: (context, isDark, _) {
        if (Responsive.isMobile(context)) {
          return HomeMobileView(selectedIndex: widget.selectedIndex);
        } else {
          return HomeWebView(selectedIndex: widget.selectedIndex);
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:arvoituskortit/theme/app_theme.dart';

class GradientScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? bottomBar;
  const GradientScaffold({super.key, this.appBar, required this.body, this.bottomBar});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Taustagradientti: [violetti -> tumma -> vihreä]
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.0, 0.45, 1.0],
              colors: [AppColors.primary, AppColors.background, AppColors.secondary],
            ),
          ),
        ),
        // Hento "sumu" tuo mystiikkaa
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: const SizedBox.expand(),
        ),
        // Varsinainen sisältö läpikuultavalla scaffoldilla
        Scaffold(
          backgroundColor: Colors.black.withOpacity(0.08),
          appBar: appBar,
          body: body,
          bottomNavigationBar: bottomBar,
        ),
      ],
    );
  }
}

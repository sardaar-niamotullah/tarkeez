import 'package:tarkeez/core/shared_files/widgets/hero_image_background_layer.dart';
import 'package:tarkeez/core/shared_files/widgets/logo_widget.dart';
import 'package:tarkeez/features/auth/presentation/sections/auth_bottom_cta_section.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: .topCenter,
          end: .bottomCenter,
          colors: [scheme.primary, scheme.primary],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // ────────────────────────────────────────────────────────────
            // Auth bg layer
            // ────────────────────────────────────────────────────────────
            const Positioned.fill(
              child: HeroImageBackgroundLayer(boxFit: .cover),
            ),

            SafeArea(
              child: Column(
                crossAxisAlignment: .stretch,
                children: [
                  const Spacer(flex: 3),
                  // ──────────────────────────────────────────────────────────
                  // App logo and titile
                  // ──────────────────────────────────────────────────────────
                  const LogoWidget(),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          ],
        ),
        // ──────────────────────────────────────────────────────────
        // Main auth part
        // ──────────────────────────────────────────────────────────
        bottomNavigationBar: const AuthBottomCTASection(),
      ),
    );
  }
}

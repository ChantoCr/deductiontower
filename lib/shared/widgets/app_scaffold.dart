import 'package:anime_deduction_tower/shared/styles/app_gradients.dart';
import 'package:anime_deduction_tower/shared/styles/app_spacing.dart';
import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.child,
    this.title,
    this.actions,
    this.bottomBar,
    super.key,
  });

  final Widget child;
  final String? title;
  final List<Widget>? actions;
  final Widget? bottomBar;

  @override
  Widget build(BuildContext context) {
    final decoratedBody = Container(
      decoration: const BoxDecoration(gradient: AppGradients.screenBackground),
      child: SafeArea(
        bottom: bottomBar == null,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: child,
        ),
      ),
    );

    return Scaffold(
      appBar: title == null
          ? null
          : AppBar(
              title: Text(title!),
              actions: actions,
            ),
      body: decoratedBody,
      bottomNavigationBar: bottomBar == null
          ? null
          : Container(
              decoration: const BoxDecoration(
                gradient: AppGradients.screenBackground,
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    0,
                    AppSpacing.lg,
                    AppSpacing.lg,
                  ),
                  child: bottomBar,
                ),
              ),
            ),
    );
  }
}

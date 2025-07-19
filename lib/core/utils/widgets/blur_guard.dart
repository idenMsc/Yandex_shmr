import 'dart:ui';
import 'package:flutter/material.dart';

class BlurGuard extends StatefulWidget {
  final Widget child;
  const BlurGuard({required this.child, super.key});

  @override
  State<BlurGuard> createState() => _BlurGuardState();
}

class _BlurGuardState extends State<BlurGuard> with WidgetsBindingObserver {
  bool _blur = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _blur = state == AppLifecycleState.inactive ||
          state == AppLifecycleState.paused;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_blur)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

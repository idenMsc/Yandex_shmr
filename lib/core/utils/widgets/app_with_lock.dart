import 'package:flutter/material.dart';
import 'package:shmr_25/features/settings/pin_code_service.dart';
import 'package:shmr_25/features/settings/pin_code_screen.dart';

class AppWithLock extends StatefulWidget {
  final Widget child;
  const AppWithLock({super.key, required this.child});

  @override
  State<AppWithLock> createState() => _AppWithLockState();
}

class _AppWithLockState extends State<AppWithLock> with WidgetsBindingObserver {
  bool _locked = true;
  bool _checking = true;
  bool _authInProgress = false;
  bool _biometricDialogOpen = false;
  bool _biometricWasAttempted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkLock();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      setState(() {
        _locked = true;
        _biometricWasAttempted = false;
      });
    }
    if (state == AppLifecycleState.resumed) {
      if (!_authInProgress && !_biometricDialogOpen && _locked) {
        _checkLock();
      }
    }
  }

  Future<void> _checkLock() async {
    if (_authInProgress || _biometricDialogOpen) return;
    _authInProgress = true;
    setState(() {
      _checking = true;
    });
    final pinService = PinCodeService();
    final bioService = BiometricService();
    final hasPin = await pinService.hasPin();
    final bioEnabled = await bioService.isBiometricEnabled();
    if (hasPin) {
      if (bioEnabled && !_biometricWasAttempted) {
        _biometricDialogOpen = true;
        final bioOk = await bioService.authenticate();
        _biometricDialogOpen = false;
        _biometricWasAttempted = true;
        if (bioOk) {
          setState(() {
            _locked = false;
            _checking = false;
          });
          _authInProgress = false;
          return;
        } else {
          setState(() {
            _locked = true;
            _checking = false;
          });
          _authInProgress = false;
          return;
        }
      }
      setState(() {
        _locked = true;
        _checking = false;
      });
    } else {
      setState(() {
        _locked = false;
        _checking = false;
      });
    }
    _authInProgress = false;
  }

  void _onPinSuccess() {
    setState(() {
      _locked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Stack(
      children: [
        widget.child,
        if (_locked)
          Material(
            color: Colors.white,
            child: PinCodeScreen(
                mode: PinCodeMode.enter, onSuccess: _onPinSuccess),
          ),
      ],
    );
  }
}

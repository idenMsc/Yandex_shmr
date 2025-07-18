import 'package:flutter/material.dart';
import 'pin_code_service.dart';

enum PinCodeMode { set, confirm, enter }

class PinCodeScreen extends StatefulWidget {
  final PinCodeMode mode;
  final String? oldPin;
  final void Function()? onSuccess;

  const PinCodeScreen({
    super.key,
    required this.mode,
    this.oldPin,
    this.onSuccess,
  });

  @override
  State<PinCodeScreen> createState() => _PinCodeScreenState();
}

class _PinCodeScreenState extends State<PinCodeScreen> {
  final List<String> _input = [];
  String? _error;
  final PinCodeService _service = PinCodeService();

  void _onKeyTap(String digit) {
    if (_input.length >= 4) return;
    setState(() {
      _input.add(digit);
      _error = null;
    });
    if (_input.length == 4) {
      _onPinEntered(_input.join());
    }
  }

  void _onBackspace() {
    if (_input.isNotEmpty) {
      setState(() {
        _input.removeLast();
        _error = null;
      });
    }
  }

  Future<void> _onPinEntered(String pin) async {
    switch (widget.mode) {
      case PinCodeMode.set:
        setState(() {
          _input.clear();
        });
        await Future.delayed(const Duration(milliseconds: 200));
        setState(() {
          _error = null;
        });
        if (mounted) {
          final navigator = Navigator.of(context);
          if (mounted) {
            navigator.pushReplacement(
              MaterialPageRoute(
                builder: (_) => PinCodeScreen(
                  mode: PinCodeMode.confirm,
                  oldPin: pin,
                  onSuccess: widget.onSuccess,
                ),
              ),
            );
          }
        }
        break;
      case PinCodeMode.confirm:
        if (pin == widget.oldPin) {
          await _service.setPin(pin);
          widget.onSuccess?.call();
          if (mounted) Navigator.of(context, rootNavigator: true).pop();
        } else {
          setState(() {
            _error = 'PIN не совпадает';
            _input.clear();
          });
        }
        break;
      case PinCodeMode.enter:
        final ok = await _service.checkPin(pin);
        if (ok) {
          widget.onSuccess?.call();
        } else {
          setState(() {
            _error = 'Неверный PIN';
            _input.clear();
          });
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _PinIndicators(length: _input.length, error: _error),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            ),
          const SizedBox(height: 24),
          _NumPad(onKeyTap: _onKeyTap, onBackspace: _onBackspace),
        ],
      ),
    );
  }

  String _getTitle() {
    switch (widget.mode) {
      case PinCodeMode.set:
        return 'Придумайте PIN-код';
      case PinCodeMode.confirm:
        return 'Повторите PIN-код';
      case PinCodeMode.enter:
        return 'Введите PIN-код';
    }
  }
}

class _PinIndicators extends StatelessWidget {
  final int length;
  final String? error;
  const _PinIndicators({required this.length, this.error});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (i) {
        return Container(
          margin: const EdgeInsets.all(8),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: i < length
                ? (error == null ? Colors.black : Colors.red)
                : Colors.transparent,
            border:
                Border.all(color: error == null ? Colors.black : Colors.red),
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}

class _NumPad extends StatelessWidget {
  final void Function(String) onKeyTap;
  final VoidCallback onBackspace;
  const _NumPad({required this.onKeyTap, required this.onBackspace});

  @override
  Widget build(BuildContext context) {
    final keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['', '0', '<'],
    ];
    return Column(
      children: keys.map((row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: row.map((key) {
            if (key == '') {
              return const SizedBox(width: 70, height: 70);
            } else if (key == '<') {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: GestureDetector(
                  onTap: onBackspace,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(Icons.backspace, color: Colors.red, size: 32),
                    ),
                  ),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: GestureDetector(
                  onTap: () => onKeyTap(key),
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        key,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
          }).toList(),
        );
      }).toList(),
    );
  }
}

import 'dart:async';

typedef VoidCallback = void Function();

class Debouncer {
  final Duration delay;
  VoidCallback? _action;
  Timer? _timer;

  Debouncer({this.delay = const Duration(seconds: 3)});

  void run(VoidCallback action) {
    _action = action;
    _timer?.cancel();
    _timer = Timer(delay, () {
      if (_action == action) {
        action();
        _action = null;
      }
      _timer = null;
    });
  }

  void cancel() {
    _timer?.cancel();
    _timer = null;
    _action = null;
  }
}


typedef VoidCallback = void Function();

class Debouncer {
  final Duration delay;
  VoidCallback? _action;

  Debouncer({this.delay = const Duration(seconds: 3)});

  void run(VoidCallback action) {
    _action = action;
    Future.delayed(delay, () {
      if (_action == action) {
        action();
        _action = null;
      }
    });
  }

  void cancel() {
    _action = null;
  }
}


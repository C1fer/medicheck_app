import 'dart:async';

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({this.milliseconds = 200});

  run(void Function() action) {
    if (_timer!= null) {
      _timer?.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void dispose() {
    _timer?.cancel();
  }
}
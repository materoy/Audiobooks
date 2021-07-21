import 'dart:developer' as dev;

class Logger {
  static void log(String value) {
    dev.log(
      value,
      time: DateTime.now(),
      name: 'Audiobooks',
    );
  }
}

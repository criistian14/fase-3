// ignore_for_file: avoid_print

abstract class LogHelper {
  const LogHelper();

  void showError(Exception error);
  void showSuccess(Object message, {String? title});
}

class LogHelperImpl extends LogHelper {
  const LogHelperImpl();

  static const String _red = '\x1B[31m';
  static const String _green = '\x1B[32m';
  static const String _bold = '\x1B[1m';
  static const String _noBold = '\x1B[22m';
  static const String _reset = '\x1B[0m';

  String get _getDivider => '_' * 80;

  String _formatTime(DateTime time) {
    final minute = time.minute < 9 ? '0${time.minute}' : time.minute;
    final second = time.second < 9 ? '0${time.second}' : time.second;

    return '${time.hour}:$minute:$second ${time.millisecond}ms';
  }

  @override
  void showError(Exception error) {
    final now = DateTime.now();

    print('$_red $_getDivider \n\n'
        '  $_bold[Error]$_noBold | ${_formatTime(now)} | '
        '$error \n $_getDivider $_reset');
  }

  @override
  void showSuccess(
    Object message, {
    String? title,
  }) {
    final now = DateTime.now();

    print('$_green $_getDivider \n\n'
        '  $_bold[${title ?? 'Success'}]$_noBold | ${_formatTime(now)} | '
        '$message \n $_getDivider $_reset');
  }
}

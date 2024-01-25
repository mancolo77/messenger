import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyDateUtil {
  static String getFormattedTime({
    required BuildContext context,
    required String time,
  }) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return _getFormattedTime(date);
  }


  static String getLastMessageTime({
    required BuildContext context,
    required String time,
    bool showYear = false,
  }) {
    final DateTime sent = DateTime.parse(time);
    final DateTime now = DateTime.now();

    return (now.day == sent.day &&
            now.month == sent.month &&
            now.year == sent.year)
        ? _getFormattedTime(sent)
        : (showYear)
            ? '${sent.day} ${_getMonth(sent)} ${sent.year}'
            : '${sent.day} ${_getMonth(sent)}';
  }

  static String getLastActiveTime({
    required BuildContext context,
    required String lastActive,
  }) {
    final int i = int.tryParse(lastActive) ?? -1;

    if (i == -1) return 'Недоступно узнать';

    DateTime time = DateTime.fromMillisecondsSinceEpoch(i);
    DateTime now = DateTime.now();
    String formattedTime = _getFormattedTime(time);

    if (time.day == now.day && time.month == now.month && time.year == now.year) {
      return 'Последний раз сегодня в $formattedTime';
    }

    if ((now.difference(time).inHours / 24).round() == 1) {
      return 'Последний раз вчера в $formattedTime';
    }

    String month = _getMonth(time);
    return 'Последний раз ${time.day} $month в $formattedTime';
  }

  static String _getFormattedTime(DateTime date) {
    return DateFormat.Hm().format(date); // 24-часовой format
  }

  static String _getMonth(DateTime date) {
    switch (date.month) {
      case 1: return 'ЯНВ';
      case 2: return 'ФЕВ';
      case 3: return 'МАР';
      case 4: return 'АПР';
      case 5: return 'МАЙ';
      case 6: return 'ИЮН';
      case 7: return 'ИЮЛ';
      case 8: return 'АВГ';
      case 9: return 'СЕНТ';
      case 10: return 'ОКТ';
      case 11: return 'НОЯБ';
      case 12: return 'ДЕК';
    }
    return 'Ошибка';
  }
}

import 'package:intl/intl.dart';

class Date extends DateTime {
  Date(int year, int month, int day): super(year, month, day);

  String format(String format) {
    return DateFormat(format, "de_DE").format(this);
  }

  static Date parse(String formattedString) {
    DateTime parsedDate = DateTime.parse(formattedString);
    return Date(parsedDate.year, parsedDate.month, parsedDate.day);
  }
  static Date tryParse(String formattedString) {
    DateTime parsedDate = DateTime.tryParse(formattedString);
    return parsedDate != null ? Date(parsedDate.year, parsedDate.month, parsedDate.day) : null;
  }

  static Date today() {
    DateTime now = DateTime.now();
    return Date(now.year, now.month, now.day);
  }
}
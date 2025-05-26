import 'package:intl/intl.dart';

class TextFormat {
  static String getDateFormat(DateTime date, {String format = 'dd-MM-yyyy HH:mm', bool showUTC = false}) {
    return DateFormat(format).format(showUTC ? date.toUtc() : date.toLocal());
  }
}

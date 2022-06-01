import 'package:date_format/date_format.dart';
class DateFormatter {
  static String dateToDDMMYY(DateTime time) {
    return formatDate(time, [dd, '.', mm, '.', yy]);
  }
}
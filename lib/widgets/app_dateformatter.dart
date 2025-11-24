import 'package:intl/intl.dart';

class DateFormatter {

  static String format(String isoDate) {
    if (isoDate.isEmpty) return "-";
    try {
      final date = DateTime.parse(isoDate);
      return DateFormat("dd/MM/yyyy").format(date);
    } catch (_) {
      return isoDate;
    }
  }
  
}

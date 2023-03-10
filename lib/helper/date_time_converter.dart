import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';

class DateTimeConverter {
  static DateTime getDateTimeFromStamp(int timeStamp) {
    return DateTime.fromMillisecondsSinceEpoch(timeStamp).toLocal();
  }
  static String getFormattedDate(DateTime dateTime, [String format = 'yyyy-MM-dd – kk:mm']){
    return DateFormat(format).format(dateTime);
  }
}
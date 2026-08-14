import 'extensions.dart';

extension DateTimeExtensions on DateTime {
  DateTime dateWithInterval(int minuteInterval) {
    return add(
      Duration(
        minutes: minuteInterval - minute % minuteInterval,
      ),
    );
  }

  String get dateFormat => DateFormat.yMMMd().format(this);

  DateTime get firstDayOfMonth => DateTime(
        DateTime.now().year,
        DateTime.now().month,
      );

  DateTime get lastDayOfMonth => DateTime(
        DateTime.now().year,
        DateTime.now().month + 1,
        0,
      );

  bool isAfterOrEqual(DateTime other) {
    return isAtSameMomentAs(other) || isAfter(other);
  }

  bool isBeforeOrEqual(DateTime other) {
    return isAtSameMomentAs(other) || isBefore(other);
  }

  bool isBetween({required DateTime from, required DateTime to}) {
    return isAfterOrEqual(from) && isBeforeOrEqual(to);
  }

  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool get isToday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(year, month, day);
    return date == today;
  }

  String monthDayFormat({bool reverse = false}) {
    final pattern = reverse ? 'd MMM' : 'MMM d';
    final formatter = DateFormat(pattern);
    final monthlyFormat = formatter.format(toLocal());
    return (monthlyFormat[0].toUpperCase() + monthlyFormat.substring(1))
        .replaceAll('.', '');
  }

  String monthDayYearFormat({bool reverse = false}) {
    final pattern = reverse ? 'd MMM yyyy' : 'MMM d yyyy';
    final formatter = DateFormat(pattern);
    final monthlyFormat = formatter.format(toLocal());
    return (monthlyFormat[0].toUpperCase() + monthlyFormat.substring(1))
        .replaceAll('.', '');
  }

  String get formatTimeAgo {
    final now = DateTime.now();
    final diff = now.difference(this);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';

    if (now.year == year) {
      return DateFormat('MMM d').format(this); // Jan 3
    }

    final shortYear = DateFormat('yy').format(this); // 24
    return "${DateFormat('MMM').format(this)} ‘$shortYear"; // Dec ‘24
  }
}

class TimeUntil {
  static String format(DateTime time) {
    DateTime currentTime = DateTime.now().toUtc();

    var timeDiff =
        time.millisecondsSinceEpoch - currentTime.millisecondsSinceEpoch;

    final num seconds = timeDiff / 1000;
    final num minutes = seconds / 60;
    final num hours = minutes / 60;
    final num days = hours / 24;
    final num weeks = days / 7;
    final num months = days / 30;
    final num years = days / 365;

    if (seconds < 60) {
      return "less than 1 minute";
    } else if (minutes < 60) {
      return "${minutes.floor()} minutes";
    } else if (hours < 24) {
      return "${hours.floor()} hours";
    } else if (days < 7) {
      return "${days.floor()} days";
    } else if (weeks < 4) {
      return "${weeks.floor()} weeks";
    } else if (months > 1 && months < 2) {
      return "${months.floor()} month";
    } else if (months > 2) {
      return "${months.floor()} months";
    } else if (years > 1 && years < 2) {
      return "${years.floor()} year";
    } else if (years > 2) {
      return "${years.floor()} years";
    } else {
      return "0 minutes";
    }
  }
}

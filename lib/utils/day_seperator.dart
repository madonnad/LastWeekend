class DaySeperator {
  static String dayItem(DateTime itemDT) {
    DateTime localItem = itemDT.toLocal();
    int itemDay = localItem.day;
    int itemMonth = localItem.month;
    int itemYear = localItem.year;

    DateTime now = DateTime.now();
    int day = now.day;
    int month = now.month;
    int year = now.year;

    DateTime itemSimpleDay = DateTime(itemYear, itemMonth, itemDay);
    DateTime today = DateTime(year, month, day);

    Duration difference = today.difference(itemSimpleDay);
    int dayDifference = difference.inDays;

    if (dayDifference == 0) {
      return "Today";
    } else if (dayDifference == 1) {
      return "Yesterday";
    } else if (dayDifference <= 6) {
      return "$dayDifference Days Ago";
    } else if (dayDifference >= 7 && dayDifference <= 31) {
      int numWeeks = (dayDifference / 7).ceil();
      return "$numWeeks Weeks Ago";
    } else if (dayDifference >= 31) {
      int numMonths = (dayDifference / 31).ceil();
      return "$numMonths Months Ago";
    } else {
      return "A Long Time Ago";
    }
  }
}

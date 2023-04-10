class DateTimeHelpers {
  DateTime today = DateTime.now();
  static DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

  static DateTime getWeekDates(
      {bool firstDate = false,
      bool lastDate = false,
      bool byNum = false,
      int num = 0}) {
    DateTime _today = DateTime.now();
    dynamic res;
    if (_today.weekday == 7 && firstDate) {
      res = getDate(_today.add(Duration(days: 1)));
      return DateTime(res.year, res.month, res.day);
    } else if (_today.weekday == 7 && lastDate) {
      res = getDate(_today.add(Duration(days: 6)));
      return DateTime(res.year, res.month, res.day);
    } else if (firstDate) {
      res = getDate(_today.subtract(Duration(days: _today.weekday - 1)));
      return DateTime(res.year, res.month, res.day);
    } else if (lastDate) {
      res = getDate(
          _today.add(Duration(days: DateTime.daysPerWeek - _today.weekday)));
      return DateTime(res.year, res.month, res.day);
    } else if (byNum) {
      DateTime res = _today.weekday == num
          ? getDate(_today)
          : num > _today.weekday
              ? _today.add(Duration(days: num - _today.weekday))
              : _today.subtract(Duration(days: _today.weekday - num));
      return DateTime(res.year, res.month, res.day);
    } else {
      res = DateTime(_today.year, _today.month, _today.day);
      return DateTime(res.year, res.month, res.day);
    }
  }

  static final dayToInt = {
    "Monday": 1,
    "Tuesday": 2,
    "Wednesday": 3,
    "Thursday": 4,
    "Friday": 5,
    "Saturday": 6,
    "Sunday": 7
  };

  static final intToDay = {
    1: "Monday",
    2: "Tuesday",
    3: "Wednesday",
    4: "Thursday",
    5: "Friday",
    6: "Saturday",
    7: "Sunday"
  };

  static List allDatesForWeek() {
    DateTime startAt = getWeekDates(firstDate: true);
    List dates = [];

    for (int i = 0; i < 7; i++) {
      dates.add(getDate(startAt.add(Duration(days: i))));
    }
    return dates;
  }
}

getMonth(date) {
  String month = date.toString().substring(5, 7);

  Map<String, String> mapMonthName = {
    "01": "Jan",
    "02": "Feb",
    "03": "Mar",
    "04": "Apr",
    "05": "May",
    "06": "Jun",
    "07": "Jul",
    "08": "Aug",
    "09": "Sept",
    "10": "Oct",
    "11": "Nov",
    "12": "Dec",
  };
  String monthName = mapMonthName[month]!;
  return monthName;
}

getHour(date) {
  List<String> parts = date.split(':');
  int hour = int.parse(parts[0]);
  List<String> listOfTime = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
  ];
  if (listOfTime.contains(hour.toString())) {
    return hour.toString();
  } else {
    Map<String, String> mapTime = {
      "13": "01",
      "14": "02",
      "15": "03",
      "16": "04",
      "17": "05",
      "18": "06",
      "19": "07",
      "20": "08",
      "21": "09",
      "22": "10",
      "23": "11",
      "24": "12",
    };
    String time = mapTime[hour.toString()]!;
    return time;
  }
}

getAmPm(date) {
  List<String> parts = date.split(':');
  int hour = int.parse(parts[0]);
  List<String> listOfTime = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
  ];
  if (listOfTime.contains(hour.toString())) {
    return 'AM';
  } else {
    return 'PM';
  }
}

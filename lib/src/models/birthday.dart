import 'package:birthdays/src/models/date.dart';

class Birthday {
  static const UNDEFINED_YEAR = 9999;

  final int id;
  String name;
  Date date;
  bool favorite;

  Birthday(this.name, this.date, {favorite = false, this.id})
      : favorite = favorite;

  Date get nextBirthday {
    /**
     * Returns next birthday, which is today or in the future
     */
    Date today = Date.today();
    Date birthdayThisYear = Date(today.year, date.month, date.day);
    if (today.isBefore(birthdayThisYear) || today.isAtSameMomentAs(birthdayThisYear))
      return birthdayThisYear;
    else
      return Date(today.year + 1, date.month, date.day);
  }

  int get age {
    if (date.year != UNDEFINED_YEAR)
      return nextBirthday.year - date.year;
    else
      return null;
  }

  int get durationInDays {
    return nextBirthday.difference(Date.today()).inDays;
  }

  String get duration {
    int days = durationInDays;
    if (days == 0)
      return "heute";
    else if (days == 1)
      return "morgen";
    else if (days <= 30)
      return "$days Tage";
    else {
      int months = (days / 30).floor();
      return "$months Monat" + (months == 1 ? "" : "e");
    }
  }


  Birthday.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        date = Date.parse(map["birthday"]),
        favorite = map["favorite"] == 1 ? true : false;

  Map<String, dynamic> toMap() => <String, dynamic>{
    "name": name,
    "birthday": date.toIso8601String(),
    "favorite": favorite ? 1 : 0,
  };
}

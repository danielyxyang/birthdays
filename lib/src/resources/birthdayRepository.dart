

import 'dart:convert';
import 'dart:io';

import 'package:birthdays/src/models/date.dart';
import 'package:birthdays/src/models/birthday.dart';
import 'package:birthdays/src/resources/database.dart';
import 'package:sqflite/sqflite.dart';

class BirthdayRepository {
  Future<List<Birthday>> getAllBirthdays() async {
    final db = await DBProvider.database;
    var result = await db.query("birthday");
    print("Received ${result.length} results");  //TODO remove print
    List<Birthday> birthdays = result.isNotEmpty ? result.map((b) => Birthday.fromMap(b)).toList(): [];
    return birthdays;
  }

  Future<int> newBirthday(Birthday birthday) async {
    final db = await DBProvider.database;
    return await db.insert("birthday", birthday.toMap());
  }

  Future<int> updateBirthday(Birthday birthday) async {
    final db = await DBProvider.database;
    return await db.update("birthday", birthday.toMap(), where: "id = ?", whereArgs: [birthday.id]);
  }

  Future<int> deleteBirthday(int id) async {
    final db = await DBProvider.database;
    return await db.delete("birthday", where: "id = ?", whereArgs: [id]);
  }

  Future<void> importBirthdays(List<Birthday> birthdays) async {
    final db = await DBProvider.database;
    Batch batch = db.batch();
    batch.delete("birthday");
    for (Birthday birthday in birthdays) {
      batch.insert("birthday", birthday.toMap());
    }
    await batch.commit(noResult: true);
  }

  Future<List<Birthday>> getBirthdaysFromCSV(String path) async {
    File file = new File(path);
    Stream<List> stream = file.openRead();
    List<Birthday> birthdays = [];
//    List<String> incorrectData = []; //TODO print skipped data
    await stream.transform(utf8.decoder).transform(LineSplitter()).forEach((String line) {
      List row = line.split(";");
      String name = row[0];
      String birthdayString = row[1];

      Date birthday = Date.tryParse(birthdayString);
      if(birthday != null) {
        birthdays.add(Birthday(name, birthday, id: birthdays.length));
      }
      else {
//        incorrectData.add(line);
        print(line);
      }
    });

    return birthdays;
  }
}
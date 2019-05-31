
import 'dart:async';

import 'package:birthdays/src/blocs/blocProvider.dart';
import 'package:birthdays/src/models/birthday.dart';
import 'package:birthdays/src/resources/birthdayRepository.dart';

class ImportBirthdaysBloc extends BlocBase {
  final _repository = BirthdayRepository();
  final _controller = StreamController<List<Birthday>>();
  List<Birthday> _birthdays;

  Stream<List<Birthday>> get birthdaysStream => _controller.stream;

  Future<void> fetchBirthdaysFromCSV(String path) async {
    _birthdays = await _repository.getBirthdaysFromCSV(path);
    // using attribute "favorite" to determine whether to import this birthday or not
    _birthdays.forEach((birthday) => birthday.favorite = true);
    refresh();
  }

  Future<void> importBirthdays() async {
    _birthdays.removeWhere((birthday) => birthday.favorite == false);
    _birthdays.forEach((birthday) => birthday.favorite == false);
    await _repository.importBirthdays(_birthdays);
  }

  void updateBirthday(Birthday newBirthday) {
    _birthdays.removeWhere((birthday) => birthday.id == newBirthday.id);
    _birthdays.add(newBirthday);
    refresh();
  }

  void enableBirthday(int id, bool enabled) {
    _birthdays.where((birthday) => birthday.id == id).forEach((birthday) => birthday.favorite = enabled);
    refresh();
  }

  void refresh() {
    _birthdays.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    _controller.sink.add(_birthdays);
  }

  void dispose() {
    _controller.close();
  }
}

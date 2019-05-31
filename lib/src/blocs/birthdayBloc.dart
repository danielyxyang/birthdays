
import 'dart:async';
import 'package:birthdays/src/blocs/blocProvider.dart';
import 'package:birthdays/src/models/birthday.dart';
import 'package:birthdays/src/resources/birthdayRepository.dart';

class BirthdaysBloc extends BlocBase {
  final _repository = BirthdayRepository();
  final _controller = StreamController<List<Birthday>>();

  Stream<List<Birthday>> get birthdaysStream => _controller.stream;

  Future<void> fetchAllBirthdays() async {
    List<Birthday> birthdays = await _repository.getAllBirthdays();
    birthdays.sort((a, b) => a.durationInDays.compareTo(b.durationInDays));
    _controller.sink.add(birthdays);
  }

  Future<void> addBirthday(Birthday birthday) async {
    if(await _repository.newBirthday(birthday) > 0) {
      fetchAllBirthdays();
    }
  }

  Future<void> updateBirthday(Birthday birthday) async {
    if(await _repository.updateBirthday(birthday) > 0) {
      fetchAllBirthdays();
    }
  }

  Future<void> deleteBirthday(int id) async {
    if(await _repository.deleteBirthday(id) > 0) {
      fetchAllBirthdays();
    }
  }

  Future<void> deleteAllBirthdays() async { //TODO remove
    _repository.importBirthdays([]);
    fetchAllBirthdays();
  }

  void dispose() {
    _controller.close();
  }
}

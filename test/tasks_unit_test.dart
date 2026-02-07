import 'package:flutter_test/flutter_test.dart';
import 'package:hsb_kurir/data/task.dart';

void main() {
  group('Task data', () {
    test('has expected number of tasks', () {
      expect(tasks, isNotEmpty);
      expect(tasks.length, 3);
    });

    test('ids are unique and fields are valid', () {
      final ids = tasks.map((task) => task.id).toSet();
      expect(ids.length, tasks.length);

      for (final task in tasks) {
        expect(task.id, isNotEmpty);
        expect(task.title, isNotEmpty);
        expect(task.address, isNotEmpty);
        expect(task.notes, isNotEmpty);
        expect(task.location.latitude, inInclusiveRange(-90, 90));
        expect(task.location.longitude, inInclusiveRange(-180, 180));
      }
    });
  });
}

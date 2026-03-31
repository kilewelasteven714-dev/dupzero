import 'package:flutter_test/flutter_test.dart';
import 'package:dupzero/domain/entities/duplicate_file.dart';

void main() {
  group('DuplicateFile', () {
    final file = DuplicateFile(
      id: 'test-1',
      path: '/sdcard/DCIM/photo.jpg',
      name: 'photo.jpg',
      size: 4 * 1024 * 1024, // 4MB
      modifiedAt: DateTime(2024, 1, 15),
      source: FileSource.local,
    );

    test('sizeFormatted returns correct MB string', () {
      expect(file.sizeFormatted, '4.0MB');
    });

    test('sizeFormatted for KB', () {
      final small = file.copyWith(size: 512 * 1024);
      expect(small.sizeFormatted, '512.0KB');
    });

    test('sizeFormatted for bytes', () {
      final tiny = file.copyWith(size: 500);
      expect(tiny.sizeFormatted, '500B');
    });

    test('sizeFormatted for GB', () {
      final large = file.copyWith(size: 2 * 1024 * 1024 * 1024);
      expect(large.sizeFormatted, '2.00GB');
    });

    test('copyWith preserves unchanged fields', () {
      final copy = file.copyWith(name: 'renamed.jpg');
      expect(copy.id, file.id);
      expect(copy.path, file.path);
      expect(copy.size, file.size);
      expect(copy.name, 'renamed.jpg');
    });

    test('equality works correctly', () {
      final same = file.copyWith();
      expect(file, same);
    });
  });
}

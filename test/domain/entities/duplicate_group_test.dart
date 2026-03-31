import 'package:flutter_test/flutter_test.dart';
import 'package:dupzero/domain/entities/duplicate_file.dart';
import 'package:dupzero/domain/entities/duplicate_group.dart';

void main() {
  final makeFile = (String id, int size) => DuplicateFile(
    id: id,
    path: '/sdcard/$id.jpg',
    name: '$id.jpg',
    size: size,
    modifiedAt: DateTime.now(),
    source: FileSource.local,
  );

  group('DuplicateGroup', () {
    test('wastedSpace is total minus first file', () {
      final files = [
        makeFile('a', 4 * 1024 * 1024),
        makeFile('b', 4 * 1024 * 1024),
        makeFile('c', 4 * 1024 * 1024),
      ];
      final group = DuplicateGroup(
        id: 'g1',
        files: files,
        category: FileCategory.image,
        duplicateType: DuplicateType.exact,
        totalSize: 12 * 1024 * 1024,
        wastedSpace: 8 * 1024 * 1024,
        detectedAt: DateTime.now(),
      );
      expect(group.wastedSpace, 8 * 1024 * 1024);
      expect(group.files.length, 3);
    });
  });
}

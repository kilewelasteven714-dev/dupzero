import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:dupzero/core/services/hash_service.dart';

void main() {
  group('HashService', () {
    late HashService service;
    late Directory tempDir;

    setUp(() async {
      service = HashService();
      tempDir = await Directory.systemTemp.createTemp('dupzero_test_');
    });

    tearDown(() async {
      await tempDir.delete(recursive: true);
    });

    test('same content produces same hash', () async {
      final file1 = File('${tempDir.path}/a.txt')
        ..writeAsStringSync('hello dupzero by tavoo');
      final file2 = File('${tempDir.path}/b.txt')
        ..writeAsStringSync('hello dupzero by tavoo');

      final hash1 = await service.computeSha256(file1.path);
      final hash2 = await service.computeSha256(file2.path);

      expect(hash1, hash2);
    });

    test('different content produces different hash', () async {
      final file1 = File('${tempDir.path}/a.txt')
        ..writeAsStringSync('content one');
      final file2 = File('${tempDir.path}/b.txt')
        ..writeAsStringSync('content two');

      final hash1 = await service.computeSha256(file1.path);
      final hash2 = await service.computeSha256(file2.path);

      expect(hash1, isNot(hash2));
    });

    test('hash is 64 characters (SHA-256 hex)', () async {
      final file = File('${tempDir.path}/test.txt')
        ..writeAsStringSync('DupZero by Tavoo');
      final hash = await service.computeSha256(file.path);
      expect(hash.length, 64);
    });

    test('empty file has consistent hash', () async {
      final file = File('${tempDir.path}/empty.txt')
        ..writeAsStringSync('');
      final hash = await service.computeSha256(file.path);
      // SHA-256 of empty string
      expect(hash, 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855');
    });
  });
}

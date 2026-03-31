import 'dart:io';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import '../constants/app_constants.dart';

class HashService {
  Future<String> computeSha256(String filePath) async {
    final file = File(filePath);
    final output = AccumulatorSink<Digest>();
    final sink = sha256.startChunkedConversion(output);
    await for (final chunk in file.openRead()) { sink.add(chunk); }
    sink.close();
    return output.events.single.toString();
  }

  Future<List<int>> computePerceptualHash(Uint8List imageBytes) async {
    final hash = List<int>.filled(64, 0);
    if (imageBytes.isEmpty) return hash;
    int avg = imageBytes.fold(0, (s, b) => s + b) ~/ imageBytes.length;
    for (int i = 0; i < 64 && i < imageBytes.length; i++) {
      hash[i] = imageBytes[i] > avg ? 1 : 0;
    }
    return hash;
  }

  int hammingDistance(List<int> a, List<int> b) {
    if (a.length != b.length) return 64;
    int dist = 0;
    for (int i = 0; i < a.length; i++) { if (a[i] != b[i]) dist++; }
    return dist;
  }

  bool areSimilarImages(List<int> a, List<int> b) =>
      hammingDistance(a, b) <= AppConstants.pHashThreshold;
}

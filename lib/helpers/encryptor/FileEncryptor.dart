import 'dart:io';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:path_provider/path_provider.dart';

class FileEncryptor {
  static final key = encrypt.Key.fromUtf8('my32lengthsupersecretnooneknows1');
  static final iv = encrypt.IV.fromLength(16);

  static Future<File> encryptFile(File inputFile, String outputFileName) async {
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final outputPath = await _getOutputPath(outputFileName);
    final outputFile = File(outputPath + '.enc');
    final outputSink = outputFile.openWrite();

    try {
      final inputStream = inputFile.openRead();
      const chunkSize = 512 * 1024 * 1024;

      await for (final chunk
          in inputStream.map((event) => Uint8List.fromList(event))) {
        final encryptedChunk = encrypter.encryptBytes(chunk, iv: iv).bytes;
        outputSink.add(encryptedChunk);
      }
    } finally {
      await outputSink.close();
    }

    print('File successfully encrypted to: ${outputFile.path}');
    return outputFile;
  }

  static Future<String> _getOutputPath(String outputFileName) async {
    final directory = Directory.systemTemp;
    return '${directory.path}/$outputFileName';
  }

  static Future<File> decryptFile(File inputFile, String outputFileName) async {
    final fileBytes = await inputFile.readAsBytes();
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final decrypted = encrypter.decryptBytes(
      encrypt.Encrypted(fileBytes),
      iv: iv,
    );

    // Save decrypted file
    final outputPath = await _getOutputPath(outputFileName);
    return File(outputPath).writeAsBytes(decrypted);
  }
}

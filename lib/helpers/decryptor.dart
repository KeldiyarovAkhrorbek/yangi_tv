import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_dotenv/flutter_dotenv.dart';

String decryptText(String encryptedText) {
  final key = encrypt.Key.fromUtf8(dotenv.env['DEC_KEY'] ?? '');
  final iv = encrypt.IV.fromUtf8(dotenv.env['IV'] ?? '');

  final encrypter =
      encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

  final encryptedBase64 = encryptedText;
  final encrypted = encrypt.Encrypted.fromBase64(encryptedBase64);

  try {
    final decrypted = encrypter.decrypt(encrypted, iv: iv);
    return decrypted;
  } catch (e) {
    return '';
  }
}

String decryptArray(List<String> encryptedArray) {
  String decrypted = '';
  encryptedArray.forEach((element) {
    decrypted += decryptText(element);
  });

  return decrypted.replaceAll(' ', '%20');
}

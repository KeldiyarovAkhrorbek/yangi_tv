import 'package:encrypt/encrypt.dart' as encrypt;

String decryptText(String encryptedText) {
  final key = encrypt.Key.fromUtf8('op1PU19Y2JoWcj0CwKwgYTtKh8OlrR3O');
  final iv = encrypt.IV.fromUtf8('Yf3sjVzmiLgAW83a');

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

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';

class EncryptionService {
  late encrypt.IV iv;
  late encrypt.Encrypter encrypter;

  EncryptionService() {
    iv = encrypt.IV.fromBase64(const String.fromEnvironment('sciv'));
    encrypter = encrypt.Encrypter(encrypt.AES(encrypt.Key.fromBase64(const String.fromEnvironment('sck'))));
  }

  String encryptData(String plainText) {
    return encrypter.encrypt(plainText, iv: iv).base64;
  }

  String decryptData(String encryptedText) {
    return encrypter.decrypt(encrypt.Encrypted.fromBase64(encryptedText), iv: iv);
  }

  void generateKeyIV() {
    encrypt.Key generatedKey = encrypt.Key.fromSecureRandom(32);
    encrypt.IV generatedIv = encrypt.IV.fromLength(16);
    debugPrint('generatedKey ${generatedKey.base64} \n generatedIv ${generatedIv.base64}');
  }
}

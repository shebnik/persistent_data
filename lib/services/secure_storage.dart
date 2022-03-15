// ignore_for_file: constant_identifier_names

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:persistent_data/models/credit_card.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();

  static const CREDIT_CARD_KEY = "CREDIT_CARD";
  static String _getUserCardKey(int id) => "$CREDIT_CARD_KEY/$id";

  static Future<void> saveCard(int id, CreditCard card) async {
    await _storage.write(key: _getUserCardKey(id), value: card.toJson());
  }

  static Future<CreditCard?> getCard(int id) async {
    String? json = await _storage.read(key: _getUserCardKey(id));
    if (json == null) return null;
    return CreditCard.fromJson(json);
  }

  static Future<void> removeCard(int id) async {
    await _storage.delete(key: _getUserCardKey(id));
  }
}

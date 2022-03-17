import 'dart:convert';

class CreditCard {
  String number;
  String dueTo;
  int cvv;

  CreditCard({
    required this.number,
    required this.dueTo,
    required this.cvv,
  });

  CreditCard copyWith({
    String? number,
    String? dueTo,
    int? cvv,
  }) {
    return CreditCard(
      number: number ?? this.number,
      dueTo: dueTo ?? this.dueTo,
      cvv: cvv ?? this.cvv,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'number': number,
      'dueTo': dueTo,
      'cvv': cvv,
    };
  }

  factory CreditCard.fromMap(Map<String, dynamic> map) {
    return CreditCard(
      number: map['number'] ?? '',
      dueTo: map['dueTo'] ?? '',
      cvv: map['cvv']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CreditCard.fromJson(String source) => CreditCard.fromMap(json.decode(source));

  @override
  String toString() => 'CreditCard(number: $number, dueTo: $dueTo, cvv: $cvv)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is CreditCard &&
      other.number == number &&
      other.dueTo == dueTo &&
      other.cvv == cvv;
  }

  @override
  int get hashCode => number.hashCode ^ dueTo.hashCode ^ cvv.hashCode;
}

// import 'dart:convert';

// class User {
//   String firstName;
//   String lastName;
//   int age;
//   String avatar;
//   int phoneNumber;

//   User({
//     required this.firstName,
//     required this.lastName,
//     required this.age,
//     required this.avatar,
//     required this.phoneNumber,
//   });

//   User copyWith({
//     String? firstName,
//     String? lastName,
//     int? age,
//     String? avatar,
//     int? phoneNumber,
//   }) {
//     return User(
//       firstName: firstName ?? this.firstName,
//       lastName: lastName ?? this.lastName,
//       age: age ?? this.age,
//       avatar: avatar ?? this.avatar,
//       phoneNumber: phoneNumber ?? this.phoneNumber,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'firstName': firstName,
//       'lastName': lastName,
//       'age': age,
//       'avatar': avatar,
//       'phoneNumber': phoneNumber,
//     };
//   }

//   factory User.fromMap(Map<String, dynamic> map) {
//     return User(
//       firstName: map['firstName'] ?? '',
//       lastName: map['lastName'] ?? '',
//       age: map['age']?.toInt() ?? 0,
//       avatar: map['avatar'] ?? '',
//       phoneNumber: map['phoneNumber']?.toInt() ?? 0,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory User.fromJson(String source) => User.fromMap(json.decode(source));

//   @override
//   String toString() {
//     return 'User(firstName: $firstName, lastName: $lastName, age: $age, avatar: $avatar, phoneNumber: $phoneNumber)';
//   }

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;

//     return other is User &&
//         other.firstName == firstName &&
//         other.lastName == lastName &&
//         other.age == age &&
//         other.avatar == avatar &&
//         other.phoneNumber == phoneNumber;
//   }

//   @override
//   int get hashCode {
//     return firstName.hashCode ^
//         lastName.hashCode ^
//         age.hashCode ^
//         avatar.hashCode ^
//         phoneNumber.hashCode;
//   }
// }

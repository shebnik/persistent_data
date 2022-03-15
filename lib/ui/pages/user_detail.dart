import 'package:flutter/material.dart';

import 'package:persistent_data/database/database.dart';
import 'package:persistent_data/models/credit_card.dart';
import 'package:persistent_data/services/secure_storage.dart';
import 'package:persistent_data/ui/widgets/app_text_field.dart';

class UserDetail extends StatefulWidget {
  const UserDetail({
    Key? key,
    required this.user,
    required this.updateUser,
    required this.removeUser,
  }) : super(key: key);

  final User user;
  final Future<void> Function(User) updateUser;
  final Future<void> Function(User) removeUser;

  @override
  State<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  late final User user;
  CreditCard? creditCard;
  bool isLoading = true;
  int errorFieldNumber = -1;

  final _lastNameFieldController = TextEditingController();
  final _firstNameFieldController = TextEditingController();
  final _ageFieldController = TextEditingController();
  final _phoneFieldController = TextEditingController();
  final _creditCardNumberFieldController = TextEditingController();
  final _creditCardDueToFieldController = TextEditingController();
  final _creditCardCVVFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    user = widget.user;
    _initialize();
  }

  Future<void> _initialize() async {
    _lastNameFieldController.text = user.lastName;
    _firstNameFieldController.text = user.firstName;
    _ageFieldController.text = user.age.toString();
    _phoneFieldController.text = user.phoneNumber.toString();

    creditCard = await SecureStorage.getCard(user.id);
    if (creditCard == null) {
      setState(() => isLoading = false);
      return;
    }

    _creditCardNumberFieldController.text = creditCard!.number
        .toString()
        .replaceAllMapped(RegExp(r".{4}"), (match) => "${match.group(0)} ")
        .substring(0, 19);

    _creditCardDueToFieldController.text = creditCard!.dueTo
        .toString()
        .replaceAllMapped(RegExp(r".{2}"), (match) => "${match.group(0)}/")
        .substring(0, 5);

    _creditCardCVVFieldController.text = creditCard!.cvv.toString();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : pageContent(),
    );
  }

  Widget pageContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            AppTextField(
              controller: _firstNameFieldController,
              fieldType: FieldType.name,
              label: "First name",
              showError: errorFieldNumber == 0,
            ),
            AppTextField(
              controller: _lastNameFieldController,
              fieldType: FieldType.name,
              label: "Last name",
              showError: errorFieldNumber == 1,
            ),
            AppTextField(
              controller: _ageFieldController,
              fieldType: FieldType.age,
              label: "Age",
              showError: errorFieldNumber == 2,
            ),
            AppTextField(
              controller: _phoneFieldController,
              fieldType: FieldType.phoneNumber,
              label: "Phone Number",
              showError: errorFieldNumber == 3,
            ),
            AppTextField(
              controller: _creditCardNumberFieldController,
              fieldType: FieldType.creditCardNumber,
              label: "Credit card number",
              showError: errorFieldNumber == 4,
            ),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _creditCardDueToFieldController,
                    fieldType: FieldType.creditCardDueTo,
                    label: "Due to",
                    showError: errorFieldNumber == 5,
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: AppTextField(
                    controller: _creditCardCVVFieldController,
                    fieldType: FieldType.creditCardCVV,
                    label: "CVV",
                    showError: errorFieldNumber == 6,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: _remove,
                      child: const Text("Remove"),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      height: 50,
                      width: 150,
                      child: ElevatedButton(
                        child: const Text("Save"),
                        onPressed: _save,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final firstName = _firstNameFieldController.text;
    if (firstName.isEmpty) {
      errorFieldNumber = 0;
      setState(() {});
      return;
    }

    final lastName = _lastNameFieldController.text;
    if (lastName.isEmpty) {
      errorFieldNumber = 1;
      setState(() {});
      return;
    }

    final age = _ageFieldController.text;
    if (age.isEmpty) {
      errorFieldNumber = 2;
      setState(() {});
      return;
    }

    final phoneNumber = _phoneFieldController.text;
    if (phoneNumber.isEmpty) {
      errorFieldNumber = 3;
      setState(() {});
      return;
    }

    final creditCardNumber =
        _creditCardNumberFieldController.text.replaceAll(" ", "");
    if (creditCardNumber.length != 16) {
      errorFieldNumber = 4;
      setState(() {});
      return;
    }

    final dueTo = _creditCardDueToFieldController.text.replaceAll("/", "");
    if (dueTo.length != 4 || int.parse(dueTo.substring(0, 2)) > 12) {
      errorFieldNumber = 5;
      setState(() {});
      return;
    }

    final cvv = _creditCardCVVFieldController.text;
    if (cvv.length != 3) {
      errorFieldNumber = 6;
      setState(() {});
      return;
    }

    errorFieldNumber = -1;
    isLoading = true;
    setState(() {});

    await widget.updateUser(
      User(
        id: user.id,
        avatar: "",
        firstName: firstName,
        lastName: lastName,
        age: int.parse(age),
        phoneNumber: int.parse(phoneNumber),
      ),
    );

    await SecureStorage.saveCard(
      user.id,
      CreditCard(
        number: int.parse(creditCardNumber),
        dueTo: int.parse(dueTo),
        cvv: int.parse(cvv),
      ),
    );

    isLoading = false;
    setState(() {});
  }

  Future<void> _remove() async {
    await widget.removeUser(user);
    Navigator.pop(context);
  }
}

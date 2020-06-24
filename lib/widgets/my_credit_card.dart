import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:m3alem/models/freezed_classes.dart';
import 'package:m3alem/widgets/my_credit_card_widget.dart';
import 'package:m3alem/widgets/my_credit_custom_form.dart';

class MyCreditCardForm extends StatefulWidget {
  final MyCreditCardModel initialValue;
  final Function(MyCreditCardModel value) onSave;

  const MyCreditCardForm({
    Key key,
    @required this.initialValue,
    @required this.onSave,
  }) : super(key: key);
  @override
  _MyCreditCardFormState createState() => _MyCreditCardFormState();
}

class _MyCreditCardFormState extends State<MyCreditCardForm> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Credit Card View Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              MyCreditCardWidget(
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                showBackView: isCvvFocused,
                cardBgColor: Colors.grey[400],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: MyCustumCreditCardForm(
                    onCreditCardModelChange: (value, isCvvFocused) =>
                        onCreditCardModelChange(value, isCvvFocused),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void onCreditCardModelChange(
      MyCreditCardModel creditCardModel, bool isFocused) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.codeInternet;
      isCvvFocused = isFocused;
    });
  }
}

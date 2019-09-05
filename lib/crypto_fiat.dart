import 'package:flutter/material.dart';

class CryptoFiat extends StatelessWidget {
  const CryptoFiat(this.cfgi);

  final CfGuiInfo cfgi;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            cfgi.error != null
                ? cfgi.error
                : '1 ${cfgi.crypto} = ${cfgi.price} ${cfgi.fiat}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class CfGuiInfo {
  CfGuiInfo(this.crypto, this.fiat, this.price, this.error);
  String fiat;
  String crypto;
  String price;
  String error;
}

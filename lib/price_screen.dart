import 'dart:convert' as convert;
import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'coin_data.dart';
import 'crypto_fiat.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  List<CfGuiInfo> _cfGuiInfo;
  String fiat = "USD";

  initState() {
    super.initState();
    _cfGuiInfo = [
      CfGuiInfo("BTC", fiat, '?', null),
      CfGuiInfo("ETH", fiat, '?', null),
      CfGuiInfo("LTC", fiat, '?', null),
    ];

    getCoinPrices(fiat);
  }

  getCoinPrices(fiat) async {
    for (CfGuiInfo cfgi in _cfGuiInfo) {
      getCoinPrice(cfgi, fiat);
    }
  }

  getCoinPrice(CfGuiInfo cfgi, String fiat) async {
    String crypto = cfgi.crypto;
    var url =
        'https://apiv2.bitcoinaverage.com/indices/global/ticker/$crypto$fiat';
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var json = convert.jsonDecode(response.body);
      double p = json['averages']['day'];
      if (json['display_symbol'] != '$crypto-$fiat') return;
      setState(() {
        cfgi.price = p.toStringAsFixed(0);
        cfgi.error = null;
      });
    } else {
      setState(() {
        cfgi.error = 'Failed getting price.';
      });
    }
  }

  getAndroidDropDown() => DropdownButton(
        items: currenciesList.map((value) {
          return DropdownMenuItem(value: value, child: Text(value));
        }).toList(),
        value: fiat,
        onChanged: (String newValue) {
          setState(() {
            for (CfGuiInfo cfgi in _cfGuiInfo) {
              cfgi.fiat = newValue;
              cfgi.price = '?';
            }
          });
          getCoinPrices(newValue);
        },
      );

  getCupertinoPicker(scrollController) => CupertinoPicker(
        scrollController: scrollController,
        backgroundColor: Colors.lightBlue,
        children: currenciesList.map((currency) => Text(currency)).toList(),
        onSelectedItemChanged: (idx) {
          String f = currenciesList[idx];
          setState(() {
            for (CfGuiInfo cfgi in _cfGuiInfo) {
              cfgi.fiat = f;
              cfgi.price = '?';
            }
          });
          getCoinPrices(f);
        },
        itemExtent: 32,
      );

  @override
  Widget build(BuildContext context) {
    final FixedExtentScrollController scrollController =
        FixedExtentScrollController(initialItem: currenciesList.indexOf(fiat));
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[]
          ..addAll(_cfGuiInfo.map((c) => CryptoFiat(c)).toList())
          ..addAll([
            Container(
              height: 150.0,
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 30.0),
              color: Colors.lightBlue,
              child: Platform.isIOS
                  ? getCupertinoPicker(scrollController)
                  : getAndroidDropDown(),
            )
          ]),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'money_machine.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';

  Money_Machine btcmoney = Money_Machine(base: 'BTC', quote: 'USD');
  Money_Machine ltcmoney = Money_Machine(base: 'LTC', quote: 'USD');
  Money_Machine ethmoney = Money_Machine(base: 'ETH', quote: 'USD');

  double? rateBTC;
  double? rateLTC;
  double? rateETH;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    double btcRate = await btcmoney.getDataQuote();
    double lctRate = await ltcmoney.getDataQuote();
    double ethRate = await ethmoney.getDataQuote();

    setState(() {
      rateBTC = btcRate;
      rateLTC = lctRate;
      rateETH = ethRate;
    });
  }

  DropdownButton<String> androidPicker() {
    List<DropdownMenuItem<String>> items = [];

    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(child: Text(currency), value: currency);
      items.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: items,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value!;
          btcmoney.quote = selectedCurrency;
          ethmoney.quote = selectedCurrency;
          ltcmoney.quote = selectedCurrency;
        });
      },
    );
  }

  CupertinoPicker iosPicker() {
    List<Text> pickerItems = [];

    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        print(selectedIndex);
      },
      children: pickerItems,
    );
  }

  Widget getPicker() {
    if (Platform.isIOS) {
      return iosPicker();
    } else {
      return androidPicker();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Bigboy(money: btcmoney, rate: rateBTC),
          Bigboy(money: ltcmoney, rate: rateLTC),
          Bigboy(money: ethmoney, rate: rateETH),
          Container(
            height: 100.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: androidPicker(),
          ),
        ],
      ),
    );
  }
}

class Bigboy extends StatelessWidget {
  const Bigboy({
    Key? key,
    required this.money,
    this.rate,
  }) : super(key: key);

  final Money_Machine money;

  final double? rate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1${money.base} =$rate ${money.quote}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

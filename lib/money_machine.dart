
import 'package:http/http.dart' as http;
import 'dart:convert';

String apikey = '7E3569FD-0ABE-4A92-9C8B-A0DDAD19C73E';

class Money_Machine {
  Money_Machine({
    this.base,
    this.quote,
  });

  var data;
  String? base;
  String? quote;

  getDataQuote() async {
    http.Response response = await http.get(Uri.parse(
        'https://rest.coinapi.io/v1/exchangerate/$base/$quote/?apikey=7E3569FD-0ABE-4A92-9C8B-A0DDAD19C73E'));

    data = response.body;

    double rate = jsonDecode(data)['rate'];

    return rate;
  }
}

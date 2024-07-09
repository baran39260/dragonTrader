import 'package:http/http.dart' as http;
import 'dart:convert';

class BitcoinDataFetcher {
  final String apiUrl =
      'https://api.coingecko.com/api/v3/coins/bitcoin/market_chart?vs_currency=usd&days=';

  Future<List<double>> fetchData(String days) async {
    try {
      final response = await http.get(Uri.parse(apiUrl + days));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> prices = data['prices'];
        return prices.map((price) => price[1] as double).toList();
      } else {
        throw Exception('Failed to load data, status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }
}

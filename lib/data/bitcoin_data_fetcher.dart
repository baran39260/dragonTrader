// bitcoin_data_fetcher.dart

import 'package:http/http.dart' as http;
import 'dart:convert';

class BitcoinDataFetcher {
  Future<List<double>> fetchData(String days) async {
    final String apiUrl =
        'https://api.coingecko.com/api/v3/coins/bitcoin/market_chart?vs_currency=usd&days=$days';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<double> prices = List<double>.from(data['prices'].map((price) => price[1]));
        return prices;
      } else {
        throw Exception('Failed to load data, status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }
}

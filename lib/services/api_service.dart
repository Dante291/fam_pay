import 'dart:convert';
import 'package:fam_assignment/models/card_group.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl =
      'https://polyjuice.kong.fampay.co/mock/famapp/feed/home_section/?slugs=famx-paypage';

  /// Fetches card groups.
  Future<List<CardGroup>> fetchCardGroups() async {
    final url = Uri.parse(_baseUrl);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final data = jsonData[0]['hc_groups'] as List;
        return data.map((e) => CardGroup.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load card groups: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network or parsing error: $e');
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;

class GraphQLService {
  static const String apiUrl =
      "https://r4kge5xew5hujalr42pqqc2u2u.appsync-api.eu-north-1.amazonaws.com/graphql";
  static const String apiKey = "da2-equehr67andpve34uuv57jv3vm";

  static Future<List<Map<String, dynamic>>> listBusRoutes({int limit = 1000}) async {
    final String query = r'''
      query ListBusRoutes($limit: Int) {
        listBusRoutes(limit: $limit) {
          items {
            id
            from
            to
            distance
            roadway
            stops
          }
        }
      }
    ''';

    final body = jsonEncode({
      "query": query,
      "variables": {"limit": limit}
    });

    final resp = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
        "x-api-key": apiKey,
      },
      body: body,
    );

    if (resp.statusCode != 200) {
      throw Exception("GraphQL request failed: ${resp.statusCode} ${resp.body}");
    }

    final Map<String, dynamic> decoded = jsonDecode(resp.body);
    if (decoded['errors'] != null) {
      throw Exception("GraphQL errors: ${decoded['errors']}");
    }

    final items = decoded['data']?['listBusRoutes']?['items'] as List<dynamic>? ?? [];
    return items.map((e) => Map<String, dynamic>.from(e)).toList();
  }
}

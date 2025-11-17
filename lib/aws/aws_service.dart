
import 'dart:convert';
import 'package:daa_project/model/aws_route.dart';
import 'package:http/http.dart' as http;

class AwsService {

  static const String apiUrl =
      "https://r4kge5xew5hujalr42pqqc2u2u.appsync-api.eu-north-1.amazonaws.com/graphql";
  static const String apiKey = "da2-equehr67andpve34uuv57jv3vm";

  Future<List<AwsRoute>> fetchRoutes() async {
    final query = '''
      query ListBusRoutes {
        listBusRoutes(limit: 5000) {
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

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "x-api-key": apiKey,
        },
        body: jsonEncode({"query": query}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final items = data["data"]["listBusRoutes"]["items"] as List;

        return items.map((json) => AwsRoute.fromJson(json)).toList();
      } else {
        print("❌ AppSync Error: ${response.body}");
        return [];
      }
    } catch (e) {
      print("❌ Exception: $e");
      return [];
    }
  }
}

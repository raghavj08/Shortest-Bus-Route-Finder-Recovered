import 'graphql_service.dart';

class ShortestPathService {
  static Future<Map<String, dynamic>> computeShortestPath(String source, String destination) async {
    final List<Map<String, dynamic>> items = await GraphQLService.listBusRoutes(limit: 1000);

   
    final Map<String, List<Map<String, dynamic>>> byBus = {};
    for (final it in items) {
      final bus = (it['roadway'] ?? 'unknown').toString();
      byBus.putIfAbsent(bus, () => []).add(it);
    }

    Map<String, dynamic> result = {
      'source': source,
      'destination': destination,
      'best_bus': null,
      'best_route': <String>[],
      'total_distance_km': null,
      'all_available_routes': <Map<String,dynamic>>[],
    };

    int shortestDistance = 1 << 60;

    for (final entry in byBus.entries) {
      final busName = entry.key;
      final list = entry.value;

      
      final Map<String, int> idx = {};
      int counter = 0;
      for (final r in list) {
        final from = (r['from'] ?? '').toString();
        final to = (r['to'] ?? '').toString();
        if (from.isNotEmpty && !idx.containsKey(from)) idx[from] = counter++;
        if (to.isNotEmpty && !idx.containsKey(to)) idx[to] = counter++;
        if (r['stops'] is List) {
          for (final s in r['stops']) {
            final ss = s.toString();
            if (ss.isNotEmpty && !idx.containsKey(ss)) idx[ss] = counter++;
          }
        }
      }

      final int n = counter;
      if (n == 0) continue;

      
      final int INF = 1 << 60;
      final dist = List.generate(n, (_) => List<int>.filled(n, INF));
      final next = List.generate(n, (_) => List<int>.filled(n, -1));

      for (int i = 0; i < n; i++) {
        dist[i][i] = 0;
        next[i][i] = i;
      }

      
      for (final r in list) {
        final from = (r['from'] ?? '').toString();
        final to = (r['to'] ?? '').toString();
        final dRaw = r['distance'];
        final int d = (dRaw is int) ? dRaw : int.tryParse(dRaw?.toString() ?? '') ?? 0;
        if (idx.containsKey(from) && idx.containsKey(to)) {
          final i = idx[from]!;
          final j = idx[to]!;
          if (d < dist[i][j]) {
            dist[i][j] = d;
            next[i][j] = j;
          }
        }
      }

      
      for (int k = 0; k < n; k++) {
        for (int i = 0; i < n; i++) {
          if (dist[i][k] == INF) continue;
          for (int j = 0; j < n; j++) {
            if (dist[k][j] == INF) continue;
            if (dist[i][k] + dist[k][j] < dist[i][j]) {
              dist[i][j] = dist[i][k] + dist[k][j];
              next[i][j] = next[i][k];
            }
          }
        }
      }

      for (final r in list) {
        result['all_available_routes'].add({
          'bus': busName,
          'from': r['from'],
          'to': r['to'],
          'distance_km': r['distance'],
          'route': r['stops'] ?? [r['from'], r['to']],
        });
      }

      final src = source.trim();
      final dst = destination.trim();
      if (!idx.containsKey(src) || !idx.containsKey(dst)) {
        continue;
      }

      final si = idx[src]!;
      final di = idx[dst]!;
      final dval = dist[si][di];
      if (dval >= INF) continue; 

      List<String> path = [];
      int u = si;
      if (next[u][di] == -1) {
        path = [];
      } else {
        path.add(_keyByValue(idx, u));
        while (u != di) {
          u = next[u][di];
          path.add(_keyByValue(idx, u));
        }
      }

      if (dval < shortestDistance) {
        shortestDistance = dval;
        result['best_bus'] = busName;
        result['best_route'] = path;
        result['total_distance_km'] = dval;
      }
    }

    return result;
  }

  static String _keyByValue(Map<String, int> map, int value) {
    return map.entries.firstWhere((e) => e.value == value).key;
  }
}

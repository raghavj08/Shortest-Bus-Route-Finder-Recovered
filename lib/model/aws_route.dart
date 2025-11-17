class AwsRoute {
  final String id;
  final String from;
  final String to;
  final int distance;
  final String roadway;
  final List<String> stops;

  AwsRoute({
    required this.id,
    required this.from,
    required this.to,
    required this.distance,
    required this.roadway,
    required this.stops,
  });

  factory AwsRoute.fromJson(Map<String, dynamic> json) {
    return AwsRoute(
      id: json['id'],
      from: json['from'],
      to: json['to'],
      distance: json['distance'],
      roadway: json['roadway'],
      stops: List<String>.from(json['stops'] ?? []),
    );
  }
}

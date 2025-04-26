class RouteModel {
  final String from;
  final String to;
  final DateTime date;

  RouteModel({required this.from, required this.to, required this.date});

  Map<String, dynamic> toMap() {
    return {
      'from': from,
      'to': to,
      'date': date.toIso8601String(),
    };
  }

  factory RouteModel.fromMap(Map<String, dynamic> map) {
    return RouteModel(
        from: map['from'], to: map['to'], date: DateTime.parse(map['date']));
  }
}

class Period {
  final int? id;
  final String period;
  final DateTime startDate;
  final DateTime endDate;
  final String name;
  final String? description;

  Period({
    this.id,
    required this.period,
    required this.startDate,
    required this.endDate,
    required this.name,
    this.description,
  });

  factory Period.fromJson(Map<String, dynamic> json) {
    return Period(
      id: json['id'],
      period: json['period'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'period': period,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'name': name,
      'description': description,
    };
  }
}

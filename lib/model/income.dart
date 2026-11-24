class Income {
  final int? id;
  String description;
  String source;
  DateTime date;
  double value;

  Income({
    this.id,
    required this.description,
    required this.source,
    required this.date,
    required this.value,
  });
}

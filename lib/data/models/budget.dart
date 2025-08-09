class Budget {
  final int id;
  final double total;
  final DateTime period;
  final DateTime createdAt;

  const Budget({
    required this.id,
    required this.total,
    required this.period,
    required this.createdAt,
  });

  set id(int id) {
    this.id = id;
  }

  set total(double total) {
    this.total = total;
  }

  set period(DateTime period) {
    this.period = period;
  }

  set createdAt(DateTime createdAt) {
    this.createdAt = createdAt;
  }

  factory Budget.fromJson(Map<String, dynamic> json) {
    final user = Budget(
      id: json['id'],
      total: double.parse(json['value']),
      period: DateTime.parse(json['period']),
      createdAt: DateTime.parse(json['created_at']),
    );

    return user;
  }

  @override
  String toString() {
    return 'User(id: $id, total: $total, period: $period, createdAt: $createdAt)';
  }
}

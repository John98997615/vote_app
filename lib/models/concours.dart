class Concours {
  final int id;
  final String name;
  final String? description;
  final DateTime? startAt;
  final DateTime? endAt;
  final int price;
  final String status;
  final int? candidatesCount;
  final int? totalVotes;
  final int? validatedVotes;
  final int? pendingVotes;
  final double? validatedAmount;
  final double? pendingAmount;

  Concours({
    required this.id,
    required this.name,
    this.description,
    this.startAt,
    this.endAt,
    required this.price,
    required this.status,
    this.candidatesCount,
    this.totalVotes,
    this.validatedVotes,
    this.pendingVotes,
    this.validatedAmount,
    this.pendingAmount,
  });

  factory Concours.fromJson(Map<String, dynamic> json) {
    return Concours(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      startAt: json['start_at'] != null ? DateTime.parse(json['start_at']) : null,
      endAt: json['end_at'] != null ? DateTime.parse(json['end_at']) : null,
      price: json['price'] ?? 100,
      status: json['status'],
      candidatesCount: json['candidates_count'],
      totalVotes: json['total_votes'],
      validatedVotes: json['validated_votes'],
      pendingVotes: json['pending_votes'],
      validatedAmount: json['validated_amount']?.toDouble(),
      pendingAmount: json['pending_amount']?.toDouble(),
    );
  }

  bool get isActive => status == 'encours';
  bool get isEnded => status == 'terminer';
}
class Transaction {
  final int id;
  final String txRef;
  final int concourId;
  final int candidateId;
  final String payerLastName;
  final String payerFirstName;
  final String? phoneNumber;
  final int amount;
  final int votesAllocated;
  final String paymentMethod;
  final String? operatorRef;
  final String status;
  final Map<String, dynamic>? webhookPayload;
  final DateTime createdAt;

  Transaction({
    required this.id,
    required this.txRef,
    required this.concourId,
    required this.candidateId,
    required this.payerLastName,
    required this.payerFirstName,
    this.phoneNumber,
    required this.amount,
    required this.votesAllocated,
    required this.paymentMethod,
    this.operatorRef,
    required this.status,
    this.webhookPayload,
    required this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      txRef: json['tx_ref'],
      concourId: json['concour_id'],
      candidateId: json['candidate_id'],
      payerLastName: json['payer_lastName'],
      payerFirstName: json['payer_firstName'],
      phoneNumber: json['phone_number'],
      amount: json['amount'],
      votesAllocated: json['votes_allocated'],
      paymentMethod: json['payment_method'],
      operatorRef: json['operator_ref'],
      status: json['status'],
      webhookPayload: json['webhook_payload'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  bool get isCompleted => status == 'completed';
  bool get isPending => status == 'pending';
  bool get isFailed => status == 'failed';
}
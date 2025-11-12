class Vote {
  final int id;
  final int concourId;
  final int candidateId;
  final int transactionId;
  final String payerLastName;
  final String payerFirstName;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Relations (optionnelles, pour le chargement eager)
  final String? candidateName;
  final String? concourName;
  final String? candidatePhoto;

  Vote({
    required this.id,
    required this.concourId,
    required this.candidateId,
    required this.transactionId,
    required this.payerLastName,
    required this.payerFirstName,
    required this.createdAt,
    required this.updatedAt,
    this.candidateName,
    this.concourName,
    this.candidatePhoto,
  });

  factory Vote.fromJson(Map<String, dynamic> json) {
    return Vote(
      id: json['id'],
      concourId: json['concour_id'],
      candidateId: json['candidate_id'],
      transactionId: json['transaction_id'],
      payerLastName: json['payer_lastName'],
      payerFirstName: json['payer_firstName'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      candidateName: json['candidate_name'],
      concourName: json['concour_name'],
      candidatePhoto: json['candidate_photo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'concour_id': concourId,
      'candidate_id': candidateId,
      'transaction_id': transactionId,
      'payer_lastName': payerLastName,
      'payer_firstName': payerFirstName,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'candidate_name': candidateName,
      'concour_name': concourName,
      'candidate_photo': candidatePhoto,
    };
  }

  // Pour la création d'un vote
  Map<String, dynamic> toCreateJson() {
    return {
      'concour_id': concourId,
      'candidate_id': candidateId,
      'transaction_id': transactionId,
      'payer_lastName': payerLastName,
      'payer_firstName': payerFirstName,
    };
  }

  String get payerFullName => '$payerFirstName $payerLastName';

  // Méthode utilitaire pour formater la date
  String get formattedDate {
    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }

  String get formattedTime {
    return '${createdAt.hour}:${createdAt.minute.toString().padLeft(2, '0')}';
  }

  // Vérifier si le vote est récent (moins de 24h)
  bool get isRecent {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    return difference.inHours < 24;
  }

  @override
  String toString() {
    return 'Vote{id: $id, candidat: $candidateId, concours: $concourId, payeur: $payerFullName}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Vote &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          transactionId == other.transactionId;

  @override
  int get hashCode => id.hashCode ^ transactionId.hashCode;
}

// Classe pour les statistiques de votes
class VoteStats {
  final int totalVotes;
  final int validatedVotes;
  final int pendingVotes;
  final double totalAmount;
  final double validatedAmount;
  final double pendingAmount;
  final Map<String, int> votesByCandidate;
  final Map<String, int> votesByHour;
  final Map<String, int> votesByDay;

  VoteStats({
    required this.totalVotes,
    required this.validatedVotes,
    required this.pendingVotes,
    required this.totalAmount,
    required this.validatedAmount,
    required this.pendingAmount,
    required this.votesByCandidate,
    required this.votesByHour,
    required this.votesByDay,
  });

  factory VoteStats.fromJson(Map<String, dynamic> json) {
    return VoteStats(
      totalVotes: json['total_votes'] ?? 0,
      validatedVotes: json['validated_votes'] ?? 0,
      pendingVotes: json['pending_votes'] ?? 0,
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      validatedAmount: (json['validated_amount'] ?? 0).toDouble(),
      pendingAmount: (json['pending_amount'] ?? 0).toDouble(),
      votesByCandidate: Map<String, int>.from(json['votes_by_candidate'] ?? {}),
      votesByHour: Map<String, int>.from(json['votes_by_hour'] ?? {}),
      votesByDay: Map<String, int>.from(json['votes_by_day'] ?? {}),
    );
  }

  // Pourcentage de votes validés
  double get validatedPercentage {
    return totalVotes > 0 ? (validatedVotes / totalVotes) * 100 : 0;
  }

  // Pourcentage de votes en attente
  double get pendingPercentage {
    return totalVotes > 0 ? (pendingVotes / totalVotes) * 100 : 0;
  }

  // Montant moyen par vote
  double get averageAmountPerVote {
    return validatedVotes > 0 ? validatedAmount / validatedVotes : 0;
  }
}

// Classe pour les résultats d'un concours
class ConcoursResults {
  final int concourId;
  final String concourName;
  final List<CandidateResult> candidateResults;
  final int totalVotes;
  final DateTime calculationDate;

  ConcoursResults({
    required this.concourId,
    required this.concourName,
    required this.candidateResults,
    required this.totalVotes,
    required this.calculationDate,
  });

  factory ConcoursResults.fromJson(Map<String, dynamic> json) {
    final candidates = (json['candidate_results'] as List)
        .map((result) => CandidateResult.fromJson(result))
        .toList();
    
    return ConcoursResults(
      concourId: json['concour_id'],
      concourName: json['concour_name'],
      candidateResults: candidates,
      totalVotes: json['total_votes'],
      calculationDate: DateTime.parse(json['calculation_date']),
    );
  }

  // Trier les résultats par nombre de votes (décroissant)
  List<CandidateResult> get sortedResults {
    candidateResults.sort((a, b) => b.voteCount.compareTo(a.voteCount));
    return candidateResults;
  }

  // Obtenir le gagnant
  CandidateResult? get winner {
    if (candidateResults.isEmpty) return null;
    return sortedResults.first;
  }

  // Obtenir le pourcentage de votes d'un candidat
  double getCandidatePercentage(int candidateId) {
    if (totalVotes == 0) return 0;
    final candidate = candidateResults.firstWhere(
      (c) => c.candidateId == candidateId,
      orElse: () => CandidateResult(candidateId: 0, candidateName: '', voteCount: 0),
    );
    return (candidate.voteCount / totalVotes) * 100;
  }
}

// Classe pour les résultats d'un candidat
class CandidateResult {
  final int candidateId;
  final String candidateName;
  final String? candidatePhoto;
  final int voteCount;
  final double? amountCollected;

  CandidateResult({
    required this.candidateId,
    required this.candidateName,
    this.candidatePhoto,
    required this.voteCount,
    this.amountCollected,
  });

  factory CandidateResult.fromJson(Map<String, dynamic> json) {
    return CandidateResult(
      candidateId: json['candidate_id'],
      candidateName: json['candidate_name'],
      candidatePhoto: json['candidate_photo'],
      voteCount: json['vote_count'],
      amountCollected: (json['amount_collected'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'candidate_id': candidateId,
      'candidate_name': candidateName,
      'candidate_photo': candidatePhoto,
      'vote_count': voteCount,
      'amount_collected': amountCollected,
    };
  }
}

// Classe pour l'historique des votes d'un utilisateur
class UserVoteHistory {
  final String userIdentifier; // Email ou numéro de téléphone
  final List<VoteHistoryItem> votes;
  final int totalVotesCast;
  final double totalAmountSpent;

  UserVoteHistory({
    required this.userIdentifier,
    required this.votes,
    required this.totalVotesCast,
    required this.totalAmountSpent,
  });

  factory UserVoteHistory.fromJson(Map<String, dynamic> json) {
    final votesList = (json['votes'] as List)
        .map((vote) => VoteHistoryItem.fromJson(vote))
        .toList();
    
    return UserVoteHistory(
      userIdentifier: json['user_identifier'],
      votes: votesList,
      totalVotesCast: json['total_votes_cast'],
      totalAmountSpent: (json['total_amount_spent'] ?? 0).toDouble(),
    );
  }

  // Votes regroupés par concours
  Map<String, List<VoteHistoryItem>> get votesByConcours {
    final Map<String, List<VoteHistoryItem>> result = {};
    
    for (final vote in votes) {
      if (!result.containsKey(vote.concourName)) {
        result[vote.concourName] = [];
      }
      result[vote.concourName]!.add(vote);
    }
    
    return result;
  }

  // Dernier vote
  VoteHistoryItem? get lastVote {
    if (votes.isEmpty) return null;
    votes.sort((a, b) => b.voteDate.compareTo(a.voteDate));
    return votes.first;
  }
}

// Élément d'historique de vote
class VoteHistoryItem {
  final int voteId;
  final String concourName;
  final String candidateName;
  final String candidatePhoto;
  final int voteCount;
  final double amount;
  final DateTime voteDate;
  final String status; // completed, pending, failed

  VoteHistoryItem({
    required this.voteId,
    required this.concourName,
    required this.candidateName,
    required this.candidatePhoto,
    required this.voteCount,
    required this.amount,
    required this.voteDate,
    required this.status,
  });

  factory VoteHistoryItem.fromJson(Map<String, dynamic> json) {
    return VoteHistoryItem(
      voteId: json['vote_id'],
      concourName: json['concour_name'],
      candidateName: json['candidate_name'],
      candidatePhoto: json['candidate_photo'],
      voteCount: json['vote_count'],
      amount: (json['amount'] ?? 0).toDouble(),
      voteDate: DateTime.parse(json['vote_date']),
      status: json['status'],
    );
  }

  bool get isCompleted => status == 'completed';
  bool get isPending => status == 'pending';
  bool get isFailed => status == 'failed';

  String get formattedDate {
    return '${voteDate.day}/${voteDate.month}/${voteDate.year}';
  }

  String get formattedTime {
    return '${voteDate.hour}:${voteDate.minute.toString().padLeft(2, '0')}';
  }
}
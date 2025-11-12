class Candidate {
  final int id;
  final int concourId;
  final String lastName;
  final String firstName;
  final String nationality;
  final String fullDescription;
  final String profilePhoto;
  final int voteCount;

  Candidate({
    required this.id,
    required this.concourId,
    required this.lastName,
    required this.firstName,
    required this.nationality,
    required this.fullDescription,
    required this.profilePhoto,
    required this.voteCount,
  });

  factory Candidate.fromJson(Map<String, dynamic> json) {
    return Candidate(
      id: json['id'],
      concourId: json['concour_id'],
      lastName: json['last_name'],
      firstName: json['first_name'],
      nationality: json['nationality'],
      fullDescription: json['full_description'],
      profilePhoto: json['profile_photo'],
      voteCount: json['votes_count'] ?? json['vote_count'] ?? 0,
    );
  }

  String get fullName => '$firstName $lastName';
}
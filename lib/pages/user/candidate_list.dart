import 'package:flutter/material.dart';
import '../../models/candidate.dart';
import '../../models/concours.dart';
import '../../widgets/candidate_card.dart';
import 'vote_page.dart';

class CandidateList extends StatelessWidget {
  final List<Candidate> candidates;
  final Concours concours;

  const CandidateList({
    super.key,
    required this.candidates,
    required this.concours,
  });

  @override
  Widget build(BuildContext context) {
    // Trier les candidats par nombre de votes (du plus élevé au plus bas)
    candidates.sort((a, b) => b.voteCount.compareTo(a.voteCount));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: candidates.length,
      itemBuilder: (context, index) {
        final candidate = candidates[index];
        final rank = index + 1;
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: CandidateCard(
            candidate: candidate,
            rank: rank,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VotePage(
                    candidate: candidate,
                    concours: concours,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
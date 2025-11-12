import 'package:Votify/models/concours.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/api_service.dart';
import '../../models/candidate.dart';
import '../../widgets/candidate_card.dart';
import 'candidate_list.dart';

class ConcoursPage extends StatefulWidget {
  final Concours concours;

  const ConcoursPage({super.key, required this.concours});

  @override
  State<ConcoursPage> createState() => _ConcoursPageState();
}

class _ConcoursPageState extends State<ConcoursPage> {
  late Future<List<Candidate>> _futureCandidates;

  @override
  void initState() {
    super.initState();
    _futureCandidates = Provider.of<ApiService>(context, listen: false)
        .getCandidatesByConcours(widget.concours.id);
  }

  void _refreshCandidates() {
    setState(() {
      _futureCandidates = Provider.of<ApiService>(context, listen: false)
          .getCandidatesByConcours(widget.concours.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.concours.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshCandidates,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // En-tête du concours
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue[50],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.concours.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                if (widget.concours.description != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    widget.concours.description!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.people,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.concours.candidatesCount ?? 0} candidats',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.how_to_vote,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.concours.totalVotes ?? 0} votes',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Liste des candidats
          Expanded(
            child: FutureBuilder<List<Candidate>>(
              future: _futureCandidates,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          'Erreur de chargement',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _refreshCandidates,
                          child: const Text('Réessayer'),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasData) {
                  final candidates = snapshot.data!;
                  return CandidateList(
                    candidates: candidates,
                    concours: widget.concours,
                  );
                } else {
                  return const Center(child: Text('Aucun candidat'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
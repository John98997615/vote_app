import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/api_service.dart';
import '../../models/candidate.dart';
import '../../models/transaction.dart';
import '../../widgets/candidate_card.dart';
import 'candidate_details.dart';

class AdminConcoursDetails extends StatefulWidget {
  final int concoursId;

  const AdminConcoursDetails({super.key, required this.concoursId});

  @override
  State<AdminConcoursDetails> createState() => _AdminConcoursDetailsState();
}

class _AdminConcoursDetailsState extends State<AdminConcoursDetails> {
  late Future<dynamic> _futureDetails;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _futureDetails = Provider.of<ApiService>(context, listen: false)
        .getConcoursDetails(widget.concoursId);
  }

  void _refreshData() {
    setState(() {
      _futureDetails = Provider.of<ApiService>(context, listen: false)
          .getConcoursDetails(widget.concoursId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Détails du Concours'),
          bottom: TabBar(
            onTap: (index) {
              setState(() {
                _selectedTab = index;
              });
            },
            tabs: const [
              Tab(text: 'Candidats'),
              Tab(text: 'Transactions Validées'),
              Tab(text: 'Transactions En Attente'),
            ],
          ),
        ),
        body: FutureBuilder<dynamic>(
          future: _futureDetails,
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
                    const Text('Erreur de chargement'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _refreshData,
                      child: const Text('Réessayer'),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasData) {
              final data = snapshot.data as Map<String, dynamic>;
              return _buildContent(data);
            } else {
              return const Center(child: Text('Aucune donnée disponible'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildContent(Map<String, dynamic> data) {
    final concours = data['concour'];
    final candidates = (data['candidates'] as List)
        .map((json) => Candidate.fromJson(json))
        .toList();
    final transactions = data['transactions'];

    switch (_selectedTab) {
      case 0:
        return _buildCandidatesTab(candidates);
      case 1:
        return _buildTransactionsTab(transactions['validated'], 'Validées');
      case 2:
        return _buildTransactionsTab(transactions['pending'], 'En Attente');
      default:
        return const Center(child: Text('Onglet non disponible'));
    }
  }

  Widget _buildCandidatesTab(List<Candidate> candidates) {
    // Trier par nombre de votes
    candidates.sort((a, b) => b.voteCount.compareTo(a.voteCount));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: candidates.length,
      itemBuilder: (context, index) {
        final candidate = candidates[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: CandidateCard(
            candidate: candidate,
            rank: index + 1,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminCandidateDetails(candidateId: candidate.id),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildTransactionsTab(List<dynamic> transactions, String status) {
    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Aucune transaction $status',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${transaction['payer_firstName']} ${transaction['payer_lastName']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: status == 'Validées' ? Colors.green[50] : Colors.orange[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: status == 'Validées' ? Colors.green : Colors.orange,
                        ),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: status == 'Validées' ? Colors.green : Colors.orange,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('${transaction['votes_allocated']} votes'),
                Text('${transaction['amount']} FCFA'),
                Text('Moyen: ${transaction['payment_method']}'),
                Text(
                  'Date: ${DateTime.parse(transaction['created_at']).toString()}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
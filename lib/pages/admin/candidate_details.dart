import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/api_service.dart';

class AdminCandidateDetails extends StatefulWidget {
  final int candidateId;

  const AdminCandidateDetails({super.key, required this.candidateId});

  @override
  State<AdminCandidateDetails> createState() => _AdminCandidateDetailsState();
}

class _AdminCandidateDetailsState extends State<AdminCandidateDetails> {
  late Future<Map<String, dynamic>> _futureDetails;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _futureDetails = Provider.of<ApiService>(context, listen: false)
        .getCandidateDetails(widget.candidateId);
  }

  void _refreshData() {
    setState(() {
      _futureDetails = Provider.of<ApiService>(context, listen: false)
          .getCandidateDetails(widget.candidateId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Détails du Candidat'),
          bottom: TabBar(
            onTap: (index) {
              setState(() {
                _selectedTab = index;
              });
            },
            tabs: const [
              Tab(text: 'Informations'),
              Tab(text: 'Transactions'),
            ],
          ),
        ),
        body: FutureBuilder<Map<String, dynamic>>(
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
              final data = snapshot.data!;
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
    final candidate = data['candidate'];
    final transactions = data['transactions'];

    switch (_selectedTab) {
      case 0:
        return _buildInfoTab(candidate);
      case 1:
        return _buildTransactionsTab(transactions);
      default:
        return const Center(child: Text('Onglet non disponible'));
    }
  }

  Widget _buildInfoTab(Map<String, dynamic> candidate) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Photo et nom
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(candidate['profile_photo']),
                  onBackgroundImageError: (exception, stackTrace) {
                    // Gérer l'erreur d'image
                  },
                  child: candidate['profile_photo'].isEmpty
                      ? const Icon(Icons.person, size: 50)
                      : null,
                ),
                const SizedBox(height: 16),
                Text(
                  '${candidate['first_name']} ${candidate['last_name']}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  candidate['nationality'],
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Statistiques
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'Statistiques',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        'Votes Totaux',
                        '${candidate['votes_count']}',
                        Icons.how_to_vote,
                        Colors.green,
                      ),
                      _buildStatItem(
                        'Votes Validés',
                        '${candidate['total_validated_votes']}',
                        Icons.verified,
                        Colors.blue,
                      ),
                      _buildStatItem(
                        'Montant Validé',
                        '${candidate['total_validated_amount']} FCFA',
                        Icons.attach_money,
                        Colors.amber,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Description
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    candidate['full_description'],
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, size: 30, color: color),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTransactionsTab(Map<String, dynamic> transactions) {
    final validated = transactions['validated'] as List;
    final pending = transactions['pending'] as List;

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Material(
            color: Colors.white,
            child: TabBar(
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: 'Validées (${0})'),
                Tab(text: 'En Attente (${0})'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildTransactionList(validated, 'Validées'),
                _buildTransactionList(pending, 'En Attente'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList(List<dynamic> transactions, String status) {
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
          child: ListTile(
            leading: Icon(
              transaction['payment_method'] == 'tmoney' 
                  ? Icons.phone_android 
                  : Icons.phone_iphone,
              color: transaction['payment_method'] == 'tmoney' 
                  ? Colors.orange 
                  : Colors.blue,
            ),
            title: Text(
              '${transaction['payer_firstName']} ${transaction['payer_lastName']}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${transaction['votes_allocated']} votes - ${transaction['amount']} FCFA'),
                Text(
                  '${transaction['payment_method']} - ${DateTime.parse(transaction['created_at']).toString().split(' ')[0]}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: status == 'Validées' ? Colors.green[50] : Colors.orange[50],
                borderRadius: BorderRadius.circular(12),
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
          ),
        );
      },
    );
  }
}
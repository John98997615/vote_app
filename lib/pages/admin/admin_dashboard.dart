import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/api_service.dart';
import '../../../services/auth_service.dart';
import '../../../widgets/stats_card.dart';
import 'concours_list.dart';
import 'transaction_details.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  late Future<Map<String, dynamic>> _futureStats;
  late Future<List<dynamic>> _futureTransactionsSummary;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    final apiService = Provider.of<ApiService>(context, listen: false);
    _futureStats = apiService.getDashboardStats();
    _futureTransactionsSummary = apiService.getTransactionsSummary();
  }

  void _refreshData() {
    setState(() {
      _initializeData();
    });
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Déconnexion'),
          content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Provider.of<AuthService>(context, listen: false).logout();
              },
              child: const Text('Déconnexion'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de Bord Admin'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
            tooltip: 'Actualiser',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Déconnexion',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre et bienvenue
            _buildWelcomeSection(),
            const SizedBox(height: 24),
            
            // Cartes de statistiques
            Expanded(
              flex: 2,
              child: _buildStatsSection(),
            ),
            
            const SizedBox(height: 24),
            
            // Résumé des transactions
            Expanded(
              flex: 1,
              child: _buildTransactionsSummary(),
            ),
            
            const SizedBox(height: 16),
            
            // Actions rapides
            _buildQuickActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _futureStats,
      builder: (context, snapshot) {
        String welcomeText = 'Tableau de Bord';
        String subtitle = 'Chargement des données...';
        
        if (snapshot.hasData) {
          final stats = snapshot.data!;
          welcomeText = 'Tableau de Bord Admin';
          subtitle = '${stats['total_concours']} concours • ${stats['total_candidates']} candidats • ${stats['total_votes']} votes';
        } else if (snapshot.hasError) {
          subtitle = 'Erreur de chargement';
        }
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              welcomeText,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatsSection() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _futureStats,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return _buildErrorSection('Erreur de chargement des statistiques');
        } else if (snapshot.hasData) {
          final stats = snapshot.data!;
          return _buildStatsGrid(stats);
        } else {
          return _buildErrorSection('Aucune donnée disponible');
        }
      },
    );
  }

  Widget _buildStatsGrid(Map<String, dynamic> stats) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        StatsCard(
          title: 'Total Votes',
          value: '${stats['total_votes']}',
          icon: Icons.how_to_vote,
          color: Colors.blue,
          subtitle: '${stats['validated_votes']} validés',
        ),
        StatsCard(
          title: 'Votes en Attente',
          value: '${stats['pending_votes']}',
          icon: Icons.pending_actions,
          color: Colors.orange,
          subtitle: 'En cours de traitement',
        ),
        StatsCard(
          title: 'Montant Total',
          value: '${stats['total_amount']} FCFA',
          icon: Icons.attach_money,
          color: Colors.green,
          subtitle: '${stats['validated_amount']} FCFA validés',
        ),
        StatsCard(
          title: 'Concours Actifs',
          value: '${stats['total_concours']}',
          icon: Icons.event,
          color: Colors.purple,
          subtitle: '${stats['total_candidates']} candidats',
        ),
      ],
    );
  }

  Widget _buildTransactionsSummary() {
    return FutureBuilder<List<dynamic>>(
      future: _futureTransactionsSummary,
      builder: (context, snapshot) {
        return Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.receipt_long, color: Colors.blue),
                    const SizedBox(width: 8),
                    const Text(
                      'Transactions Récentes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TransactionDetails(),
                          ),
                        );
                      },
                      child: const Text('Voir tout'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (snapshot.connectionState == ConnectionState.waiting)
                  const Center(child: CircularProgressIndicator())
                else if (snapshot.hasError)
                  const Text('Erreur de chargement')
                else if (snapshot.hasData && snapshot.data!.isNotEmpty)
                  _buildTransactionsList(snapshot.data!)
                else
                  const Text('Aucune transaction récente'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTransactionsList(List<dynamic> transactions) {
    return Column(
      children: transactions.take(3).map((transaction) {
        return ListTile(
          leading: Icon(
            transaction['payment_method'] == 'tmoney' 
                ? Icons.phone_android 
                : Icons.phone_iphone,
            color: transaction['payment_method'] == 'tmoney' 
                ? Colors.orange 
                : Colors.blue,
          ),
          title: Text(
            '${transaction['amount']} FCFA',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            '${transaction['payment_method']?.toString().toUpperCase()}',
          ),
          trailing: Chip(
            label: Text(
              '${transaction['amount']} FCFA',
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildQuickActions() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Actions Rapides',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.list_alt,
                    label: 'Concours',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminConcoursList(),
                        ),
                      );
                    },
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.people,
                    label: 'Candidats',
                    onTap: () {
                      // Naviguer vers la gestion des candidats
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Gestion des candidats - À implémenter'),
                        ),
                      );
                    },
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.receipt_long,
                    label: 'Transactions',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TransactionDetails(),
                        ),
                      );
                    },
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorSection(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _refreshData,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/api_service.dart';
import '../../../models/transaction.dart';

class TransactionDetails extends StatefulWidget {
  const TransactionDetails({super.key});

  @override
  State<TransactionDetails> createState() => _TransactionDetailsState();
}

class _TransactionDetailsState extends State<TransactionDetails> {
  late Future<List<Transaction>> _futureTransactions;
  String _filterStatus = 'all';
  String _filterPaymentMethod = 'all';

  @override
  void initState() {
    super.initState();
    _futureTransactions = _loadTransactions();
  }

  Future<List<Transaction>> _loadTransactions() async {
    // Cette méthode simule le chargement des transactions
    // À remplacer par un appel API réel
    await Future.delayed(const Duration(seconds: 2));
    
    // Données simulées
    return [
      Transaction(
        id: 1,
        txRef: 'TX-001',
        concourId: 1,
        candidateId: 1,
        payerLastName: 'Doe',
        payerFirstName: 'John',
        phoneNumber: '+228 12 34 56 78',
        amount: 5000,
        votesAllocated: 5,
        paymentMethod: 'tmoney',
        status: 'completed',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      Transaction(
        id: 2,
        txRef: 'TX-002',
        concourId: 1,
        candidateId: 2,
        payerLastName: 'Smith',
        payerFirstName: 'Jane',
        phoneNumber: '+228 98 76 54 32',
        amount: 3000,
        votesAllocated: 3,
        paymentMethod: 'flooz',
        status: 'pending',
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      Transaction(
        id: 3,
        txRef: 'TX-003',
        concourId: 2,
        candidateId: 3,
        payerLastName: 'Johnson',
        payerFirstName: 'Mike',
        phoneNumber: '+228 55 44 33 22',
        amount: 10000,
        votesAllocated: 10,
        paymentMethod: 'tmoney',
        status: 'failed',
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
    ];
  }

  void _refreshTransactions() {
    setState(() {
      _futureTransactions = _loadTransactions();
    });
  }

  List<Transaction> _applyFilters(List<Transaction> transactions) {
    List<Transaction> filtered = transactions;

    // Filtre par statut
    if (_filterStatus != 'all') {
      filtered = filtered.where((t) => t.status == _filterStatus).toList();
    }

    // Filtre par méthode de paiement
    if (_filterPaymentMethod != 'all') {
      filtered = filtered.where((t) => t.paymentMethod == _filterPaymentMethod).toList();
    }

    return filtered;
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'completed':
        return 'Validée';
      case 'pending':
        return 'En attente';
      case 'failed':
        return 'Échouée';
      default:
        return status;
    }
  }

  IconData _getPaymentMethodIcon(String method) {
    switch (method) {
      case 'tmoney':
        return Icons.phone_android;
      case 'flooz':
        return Icons.phone_iphone;
      default:
        return Icons.payment;
    }
  }

  Color _getPaymentMethodColor(String method) {
    switch (method) {
      case 'tmoney':
        return Colors.orange;
      case 'flooz':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails des Transactions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshTransactions,
            tooltip: 'Actualiser',
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtres
          _buildFilters(),
          const SizedBox(height: 8),
          
          // Liste des transactions
          Expanded(
            child: FutureBuilder<List<Transaction>>(
              future: _futureTransactions,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return _buildErrorSection();
                } else if (snapshot.hasData) {
                  final transactions = _applyFilters(snapshot.data!);
                  return _buildTransactionsList(transactions);
                } else {
                  return const Center(child: Text('Aucune transaction disponible'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Filtre par statut
            Row(
              children: [
                const Icon(Icons.filter_list, size: 16),
                const SizedBox(width: 8),
                const Text('Statut:'),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButton<String>(
                    value: _filterStatus,
                    isExpanded: true,
                    items: [
                      const DropdownMenuItem(value: 'all', child: Text('Tous')),
                      const DropdownMenuItem(value: 'completed', child: Text('Validées')),
                      const DropdownMenuItem(value: 'pending', child: Text('En attente')),
                      const DropdownMenuItem(value: 'failed', child: Text('Échouées')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _filterStatus = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Filtre par méthode de paiement
            Row(
              children: [
                const Icon(Icons.payment, size: 16),
                const SizedBox(width: 8),
                const Text('Paiement:'),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButton<String>(
                    value: _filterPaymentMethod,
                    isExpanded: true,
                    items: [
                      const DropdownMenuItem(value: 'all', child: Text('Tous')),
                      const DropdownMenuItem(value: 'tmoney', child: Text('T-Money')),
                      const DropdownMenuItem(value: 'flooz', child: Text('Flooz')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _filterPaymentMethod = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsList(List<Transaction> transactions) {
    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Aucune transaction trouvée',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Ajustez vos filtres ou réessayez plus tard',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
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
        return _buildTransactionCard(transaction);
      },
    );
  }

  Widget _buildTransactionCard(Transaction transaction) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${transaction.payerFirstName} ${transaction.payerLastName}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(transaction.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getStatusColor(transaction.status),
                    ),
                  ),
                  child: Text(
                    _getStatusText(transaction.status),
                    style: TextStyle(
                      color: _getStatusColor(transaction.status),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Détails
            Row(
              children: [
                Icon(
                  _getPaymentMethodIcon(transaction.paymentMethod),
                  size: 16,
                  color: _getPaymentMethodColor(transaction.paymentMethod),
                ),
                const SizedBox(width: 8),
                Text(
                  transaction.paymentMethod.toUpperCase(),
                  style: TextStyle(
                    color: _getPaymentMethodColor(transaction.paymentMethod),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '${transaction.votesAllocated} votes',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Montant et référence
            Row(
              children: [
                const Icon(Icons.attach_money, size: 16, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  '${transaction.amount} FCFA',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.receipt, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  transaction.txRef,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Numéro de téléphone et date
            Row(
              children: [
                const Icon(Icons.phone, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    transaction.phoneNumber ?? 'Non renseigné',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  '${transaction.createdAt.day}/${transaction.createdAt.month}/${transaction.createdAt.year}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorSection() {
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
          const Text(
            'Erreur de chargement',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Impossible de charger les transactions',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _refreshTransactions,
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
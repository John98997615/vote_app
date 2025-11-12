import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/api_service.dart';
import '../../models/candidate.dart';
import '../../models/concours.dart';
import 'payment_page.dart';

class VotePage extends StatefulWidget {
  final Candidate candidate;
  final Concours concours;

  const VotePage({
    super.key,
    required this.candidate,
    required this.concours,
  });

  @override
  State<VotePage> createState() => _VotePageState();
}

class _VotePageState extends State<VotePage> {
  int _votesCount = 1;
  final _lastNameController = TextEditingController();
  final _firstNameController = TextEditingController();
  String _selectedPaymentMethod = 'tmoney';

  @override
  void dispose() {
    _lastNameController.dispose();
    _firstNameController.dispose();
    super.dispose();
  }

  void _incrementVotes() {
    setState(() {
      _votesCount++;
    });
  }

  void _decrementVotes() {
    if (_votesCount > 1) {
      setState(() {
        _votesCount--;
      });
    }
  }

  int get _totalAmount => _votesCount * widget.concours.price;

  Future<void> _proceedToPayment() async {
    if (_lastNameController.text.isEmpty || _firstNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir tous les champs'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final response = await apiService.createVoteTransaction(
        concourId: widget.concours.id,
        candidateId: widget.candidate.id,
        payerLastName: _lastNameController.text,
        payerFirstName: _firstNameController.text,
        votesRequested: _votesCount,
        paymentMethod: _selectedPaymentMethod,
      );

      // Naviguer vers la page de paiement
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentPage(
            transactionData: response,
            candidate: widget.candidate,
            concours: widget.concours,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voter pour ce candidat'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Informations du candidat
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(widget.candidate.profilePhoto),
                      onBackgroundImageError: (exception, stackTrace) {
                        // Gérer l'erreur de chargement d'image
                      },
                      child: const Icon(Icons.person),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.candidate.fullName,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          Text(
                            widget.candidate.nationality,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            '${widget.candidate.voteCount} votes',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.green,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Informations personnelles
            Text(
              'Vos informations',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(
                labelText: 'Prénom',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                labelText: 'Nom',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),

            const SizedBox(height: 24),

            // Sélection du nombre de votes
            Text(
              'Nombre de votes',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Votes sélectionnés:'),
                        Row(
                          children: [
                            IconButton(
                              onPressed: _decrementVotes,
                              icon: const Icon(Icons.remove),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.grey[200],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              '$_votesCount',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 16),
                            IconButton(
                              onPressed: _incrementVotes,
                              icon: const Icon(Icons.add),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.grey[200],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Prix par vote: ${widget.concours.price} FCFA',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Méthode de paiement
            Text(
              'Méthode de paiement',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    RadioListTile<String>(
                      title: const Row(
                        children: [
                          Icon(Icons.phone_android, color: Colors.orange),
                          SizedBox(width: 8),
                          Text('T-Money'),
                        ],
                      ),
                      value: 'tmoney',
                      groupValue: _selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          _selectedPaymentMethod = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Row(
                        children: [
                          Icon(Icons.phone_android, color: Colors.blue),
                          SizedBox(width: 8),
                          Text('Flooz'),
                        ],
                      ),
                      value: 'flooz',
                      groupValue: _selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          _selectedPaymentMethod = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Récapitulatif et bouton de paiement
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total à payer:'),
                        Text(
                          '$_totalAmount FCFA',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$_votesCount vote(s) × ${widget.concours.price} FCFA',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Bouton de paiement
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _proceedToPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'PROCÉDER AU PAIEMENT',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
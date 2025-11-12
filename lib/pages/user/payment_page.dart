import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/candidate.dart';
import '../../models/concours.dart';

class PaymentPage extends StatefulWidget {
  final Map<String, dynamic> transactionData;
  final Candidate candidate;
  final Concours concours;

  const PaymentPage({
    super.key,
    required this.transactionData,
    required this.candidate,
    required this.concours,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool _isProcessing = false;
  bool _paymentCompleted = false;
  bool _paymentFailed = false;

  Future<void> _launchPaymentUrl() async {
    final String paymentUrl = widget.transactionData['payment_url'];
    
    setState(() {
      _isProcessing = true;
    });

    try {
      if (await canLaunchUrl(Uri.parse(paymentUrl))) {
        await launchUrl(
          Uri.parse(paymentUrl),
          mode: LaunchMode.externalApplication,
        );
        
        // Simuler un délai pour le traitement (dans une vraie app, vous attendriez le webhook)
        await Future.delayed(const Duration(seconds: 5));
        
        setState(() {
          _isProcessing = false;
          _paymentCompleted = true;
        });
      } else {
        throw 'Impossible d\'ouvrir l\'URL de paiement';
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _paymentFailed = true;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _retryPayment() {
    setState(() {
      _paymentFailed = false;
    });
    _launchPaymentUrl();
  }

  void _returnToHome() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _viewTransactionDetails() {
    // Naviguer vers les détails de la transaction
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Détails de la transaction: ${widget.transactionData['tx_ref']}'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paiement'),
        leading: _paymentCompleted 
            ? IconButton(
                icon: const Icon(Icons.home),
                onPressed: _returnToHome,
              )
            : null,
      ),
      body: _isProcessing
          ? _buildProcessingView()
          : _paymentCompleted
              ? _buildSuccessView()
              : _paymentFailed
                  ? _buildFailedView()
                  : _buildPaymentView(),
    );
  }

  Widget _buildPaymentView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête
          Card(
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(
                    Icons.payment,
                    size: 64,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Paiement sécurisé',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Vous allez être redirigé vers la plateforme de paiement sécurisée FedaPay',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Récapitulatif de la transaction
          Text(
            'Récapitulatif',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildSummaryRow('Candidat', widget.candidate.fullName),
                  _buildSummaryRow('Concours', widget.concours.name),
                  _buildSummaryRow('Référence', widget.transactionData['tx_ref']),
                  _buildSummaryRow('Nombre de votes', '${widget.transactionData['votes_requested']}'),
                  _buildSummaryRow('Montant total', '${widget.transactionData['amount']} FCFA'),
                  _buildSummaryRow('Statut', 'En attente de paiement'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Instructions
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Instructions de paiement',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  _buildInstructionStep(1, 'Cliquez sur "Procéder au paiement"'),
                  _buildInstructionStep(2, 'Vous serez redirigé vers FedaPay'),
                  _buildInstructionStep(3, 'Suivez les instructions de paiement'),
                  _buildInstructionStep(4, 'Confirmez votre paiement'),
                  _buildInstructionStep(5, 'Revenez à l\'application après paiement'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Sécurité
          Card(
            color: Colors.green.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.security, color: Colors.green),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Paiement 100% sécurisé avec FedaPay',
                      style: TextStyle(
                        color: Colors.green.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Bouton de paiement
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _launchPaymentUrl,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock),
                  SizedBox(width: 8),
                  Text(
                    'PROCÉDER AU PAIEMENT SÉCURISÉ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            strokeWidth: 4,
          ),
          const SizedBox(height: 24),
          Text(
            'Traitement en cours...',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            'Veuillez patienter pendant que nous traitons votre paiement',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ne fermez pas l\'application',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.orange,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              size: 100,
              color: Colors.green,
            ),
            const SizedBox(height: 24),
            Text(
              'Paiement Réussi !',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              'Votre vote a été enregistré avec succès',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Référence: ${widget.transactionData['tx_ref']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${widget.transactionData['votes_requested']} votes pour ${widget.candidate.fullName}',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _viewTransactionDetails,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('DÉTAILS'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _returnToHome,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('ACCUEIL'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFailedView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 100,
              color: Colors.red,
            ),
            const SizedBox(height: 24),
            Text(
              'Paiement Échoué',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              'Une erreur est survenue lors du traitement de votre paiement',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Veuillez réessayer ou contacter le support',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _returnToHome,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('ACCUEIL'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _retryPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('RÉESSAYER'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: TextStyle(
              color: label.contains('Montant') ? Colors.green : null,
              fontWeight: label.contains('Montant') ? FontWeight.bold : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionStep(int step, String instruction) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$step',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(instruction),
          ),
        ],
      ),
    );
  }
}
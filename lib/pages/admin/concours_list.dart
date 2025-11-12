import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/api_service.dart';
import '../../models/concours.dart';
import '../../widgets/concours_card.dart';
import 'concours_details.dart';

class AdminConcoursList extends StatefulWidget {
  const AdminConcoursList({super.key});

  @override
  State<AdminConcoursList> createState() => _AdminConcoursListState();
}

class _AdminConcoursListState extends State<AdminConcoursList> {
  late Future<List<Concours>> _futureConcours;

  @override
  void initState() {
    super.initState();
    _futureConcours = Provider.of<ApiService>(context, listen: false).getConcoursList();
  }

  void _refreshData() {
    setState(() {
      _futureConcours = Provider.of<ApiService>(context, listen: false).getConcoursList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Concours'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: FutureBuilder<List<Concours>>(
        future: _futureConcours,
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
                    onPressed: _refreshData,
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData) {
            final concoursList = snapshot.data!;
            return _buildConcoursList(concoursList);
          } else {
            return const Center(child: Text('Aucun concours disponible'));
          }
        },
      ),
    );
  }

  Widget _buildConcoursList(List<Concours> concoursList) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: concoursList.length,
      itemBuilder: (context, index) {
        final concours = concoursList[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ConcoursCard(
            concours: concours,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminConcoursDetails(concoursId: concours.id),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
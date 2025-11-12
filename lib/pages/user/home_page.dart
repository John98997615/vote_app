import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/api_service.dart';
import '../../models/concours.dart';
import '../../widgets/concours_card.dart';
import 'concours_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        title: const Text('Concours en cours'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
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
                  const SizedBox(height: 8),
                  Text(
                    snapshot.error.toString(),
                    textAlign: TextAlign.center,
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
            final activeConcours = concoursList.where((c) => c.isActive).toList();
            final endedConcours = concoursList.where((c) => c.isEnded).toList();

            return DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.grey,
                    tabs: const [
                      Tab(text: 'Actifs'),
                      Tab(text: 'Terminés'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Onglet Concours Actifs
                        _buildConcoursList(activeConcours, true),
                        // Onglet Concours Terminés
                        _buildConcoursList(endedConcours, false),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Aucun concours disponible'));
          }
        },
      ),
    );
  }

  Widget _buildConcoursList(List<Concours> concoursList, bool isActive) {
    if (concoursList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? Icons.event_busy : Icons.history,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              isActive ? 'Aucun concours actif' : 'Aucun concours terminé',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      );
    }

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
                  builder: (context) => ConcoursPage(concours: concours),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
import 'package:flutter/material.dart';
import '../models/concours.dart';

class ConcoursCard extends StatelessWidget {
  final Concours concours;
  final VoidCallback onTap;

  const ConcoursCard({
    super.key,
    required this.concours,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête avec nom et statut
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      concours.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildStatusBadge(concours.status),
                ],
              ),

              const SizedBox(height: 12),

              // Description
              if (concours.description != null && concours.description!.isNotEmpty)
                Column(
                  children: [
                    Text(
                      concours.description!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[700],
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                  ],
                ),

              // Dates
              if (concours.startAt != null || concours.endAt != null)
                Column(
                  children: [
                    _buildDateInfo(context),
                    const SizedBox(height: 12),
                  ],
                ),

              // Statistiques
              _buildStatistics(context),

              const SizedBox(height: 8),

              // Prix par vote
              _buildPriceInfo(context),

              // Barre de progression (si le concours est actif)
              if (concours.isActive && concours.endAt != null)
                Column(
                  children: [
                    const SizedBox(height: 12),
                    _buildProgressBar(context),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final bool isActive = status == 'encours';
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? Colors.green[50] : Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? Colors.green : Colors.grey,
          width: 1,
        ),
      ),
      child: Text(
        isActive ? 'ACTIF' : 'TERMINÉ',
        style: TextStyle(
          color: isActive ? Colors.green : Colors.grey,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDateInfo(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.calendar_today,
          size: 16,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            _formatDateRange(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ),
      ],
    );
  }

  String _formatDateRange() {
    if (concours.startAt != null && concours.endAt != null) {
      final start = _formatDate(concours.startAt!);
      final end = _formatDate(concours.endAt!);
      return 'Du $start au $end';
    } else if (concours.startAt != null) {
      return 'Débute le ${_formatDate(concours.startAt!)}';
    } else if (concours.endAt != null) {
      return 'Termine le ${_formatDate(concours.endAt!)}';
    }
    return 'Dates non définies';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildStatistics(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem(
          icon: Icons.people,
          value: '${concours.candidatesCount ?? 0}',
          label: 'Candidats',
          color: Colors.blue,
        ),
        _buildStatItem(
          icon: Icons.how_to_vote,
          value: '${concours.totalVotes ?? 0}',
          label: 'Votes',
          color: Colors.green,
        ),
        _buildStatItem(
          icon: Icons.attach_money,
          value: '${concours.validatedAmount?.toStringAsFixed(0) ?? '0'}',
          label: 'FCFA',
          color: Colors.amber,
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: color,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.monetization_on,
            size: 16,
            color: Colors.blue[700],
          ),
          const SizedBox(width: 8),
          Text(
            '${concours.price} FCFA par vote',
            style: TextStyle(
              color: Colors.blue[700],
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    final now = DateTime.now();
    final start = concours.startAt!;
    final end = concours.endAt!;
    
    final totalDuration = end.difference(start).inSeconds;
    final elapsedDuration = now.difference(start).inSeconds;
    
    double progress = elapsedDuration / totalDuration;
    progress = progress.clamp(0.0, 1.0);

    final daysRemaining = end.difference(now).inDays;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progression',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              daysRemaining > 0 ? '$daysRemaining jours restants' : 'Dernier jour',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: daysRemaining <= 3 ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(
            progress > 0.8 ? Colors.orange : Colors.blue,
          ),
          minHeight: 6,
          borderRadius: BorderRadius.circular(3),
        ),
        const SizedBox(height: 4),
        Text(
          '${(progress * 100).toStringAsFixed(1)}%',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }
}
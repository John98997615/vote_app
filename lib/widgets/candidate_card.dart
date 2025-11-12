import 'package:Votify/utils/constants.dart';
import 'package:flutter/material.dart';
import '../models/candidate.dart';
import '../utils/helpers.dart';

class CandidateCard extends StatelessWidget {
  final Candidate candidate;
  final int rank;
  final VoidCallback onTap;
  final bool showRank;
  final bool showVoteCount;
  final bool compact;

  const CandidateCard({
    super.key,
    required this.candidate,
    required this.rank,
    required this.onTap,
    this.showRank = true,
    this.showVoteCount = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: compact 
          ? const EdgeInsets.symmetric(vertical: 4, horizontal: 8)
          : const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(DesignConstants.cardBorderRadius),
        child: compact ? _buildCompactContent() : _buildExpandedContent(),
      ),
    );
  }

  Widget _buildExpandedContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Badge de classement
          if (showRank) _buildRankBadge(),
          if (showRank) const SizedBox(width: 16),
          
          // Photo du candidat
          _buildCandidatePhoto(),
          const SizedBox(width: 16),
          
          // Informations du candidat
          Expanded(
            child: _buildCandidateInfo(),
          ),
          
          // Compteur de votes
          if (showVoteCount) _buildVoteCount(),
        ],
      ),
    );
  }

  Widget _buildCompactContent() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Photo du candidat (plus petite)
          _buildCompactPhoto(),
          const SizedBox(width: 12),
          
          // Informations du candidat
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  candidate.fullName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (showVoteCount) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${candidate.voteCount} votes',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.green,
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // Badge de classement compact
          if (showRank) _buildCompactRankBadge(),
        ],
      ),
    );
  }

  Widget _buildRankBadge() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: ColorHelper.getRankColor(rank),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          '$rank',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildCompactRankBadge() {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: ColorHelper.getRankColor(rank),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$rank',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildCandidatePhoto() {
    return Stack(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.grey.shade300,
              width: 2,
            ),
          ),
          child: ClipOval(
            child: Image.network(
              candidate.profilePhoto,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade200,
                  child: const Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.grey,
                  ),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        
        // Badge de statut (si nécessaire)
        if (rank <= 3)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getRankIcon(rank),
                size: 12,
                color: ColorHelper.getRankColor(rank),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCompactPhoto() {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: Image.network(
          candidate.profilePhoto,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey.shade200,
              child: const Icon(
                Icons.person,
                size: 20,
                color: Colors.grey,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCandidateInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          candidate.fullName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        
        const SizedBox(height: 4),
        
        Row(
          children: [
            Icon(
              Icons.flag,
              size: 14,
              color: Colors.grey.shade600,
            ),
            const SizedBox(width: 4),
            Text(
              candidate.nationality,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        
        if (!compact) ...[
          const SizedBox(height: 8),
          
          // Barre de progression (pour les 3 premiers)
          if (rank <= 3) _buildProgressBar(),
        ],
      ],
    );
  }

  Widget _buildProgressBar() {
    // Simulation de pourcentage (dans une vraie app, ça viendrait des données)
    final percentage = (rank == 1) ? 85.0 : (rank == 2) ? 70.0 : 55.0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${percentage.toStringAsFixed(1)}%',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            Text(
              _getRankTitle(rank),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: ColorHelper.getRankColor(rank),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: percentage / 100,
          backgroundColor: Colors.grey.shade200,
          valueColor: AlwaysStoppedAnimation<Color>(
            ColorHelper.getRankColor(rank),
          ),
          minHeight: 6,
          borderRadius: BorderRadius.circular(3),
        ),
      ],
    );
  }

  Widget _buildVoteCount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.how_to_vote,
              size: compact ? 14 : 16,
              color: Colors.green,
            ),
            const SizedBox(width: 4),
            Text(
              FormatHelper.formatVotes(candidate.voteCount),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
                fontSize: compact ? 12 : 14,
              ),
            ),
          ],
        ),
        
        if (!compact) ...[
          const SizedBox(height: 4),
          Text(
            'votes',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ],
    );
  }

  IconData _getRankIcon(int rank) {
    switch (rank) {
      case 1:
        return Icons.emoji_events;
      case 2:
        return Icons.workspace_premium;
      case 3:
        return Icons.star;
      default:
        return Icons.person;
    }
  }

  String _getRankTitle(int rank) {
    switch (rank) {
      case 1:
        return 'PREMIER';
      case 2:
        return 'DEUXIÈME';
      case 3:
        return 'TROISIÈME';
      default:
        return 'CLASSÉ';
    }
  }
}

// Variante de CandidateCard pour la sélection
class CandidateSelectionCard extends StatelessWidget {
  final Candidate candidate;
  final bool isSelected;
  final VoidCallback onTap;

  const CandidateSelectionCard({
    super.key,
    required this.candidate,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 4 : 1,
      color: isSelected ? Colors.blue.shade50 : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignConstants.cardBorderRadius),
        side: BorderSide(
          color: isSelected ? Colors.blue : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(DesignConstants.cardBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Photo du candidat
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Image.network(
                    candidate.profilePhoto,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.person,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Informations
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      candidate.fullName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      candidate.nationality,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      '${candidate.voteCount} votes',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Indicateur de sélection
              Icon(
                isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isSelected ? Colors.blue : Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
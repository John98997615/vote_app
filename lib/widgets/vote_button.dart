import 'package:Votify/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

// Bouton de vote principal
class VoteButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isLoading;
  final bool isDisabled;
  final Color backgroundColor;
  final Color textColor;
  final double width;
  final double height;
  final bool isFullWidth;
  final IconData? icon;
  final double elevation;

  const VoteButton({
    super.key,
    required this.onPressed,
    this.text = 'VOTER',
    this.isLoading = false,
    this.isDisabled = false,
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.white,
    this.width = 140,
    this.height = 50,
    this.isFullWidth = false,
    this.icon,
    this.elevation = 2,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : width,
      height: height,
      child: ElevatedButton(
        onPressed: (isDisabled || isLoading) ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                DesignConstants.buttonBorderRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: isLoading
            ? const ButtonLoadingIndicator()
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// Bouton de vote avec compteur
class VoteCounterButton extends StatefulWidget {
  final int initialVotes;
  final int minVotes;
  final int maxVotes;
  final int pricePerVote;
  final ValueChanged<int> onVoteCountChanged;
  final VoidCallback onConfirmVote;
  final bool isLoading;

  const VoteCounterButton({
    super.key,
    this.initialVotes = 1,
    this.minVotes = 1,
    this.maxVotes = 100,
    required this.pricePerVote,
    required this.onVoteCountChanged,
    required this.onConfirmVote,
    this.isLoading = false,
  });

  @override
  State<VoteCounterButton> createState() => _VoteCounterButtonState();
}

class _VoteCounterButtonState extends State<VoteCounterButton> {
  late int _voteCount;

  @override
  void initState() {
    super.initState();
    _voteCount = widget.initialVotes;
  }

  void _incrementVotes() {
    if (_voteCount < widget.maxVotes) {
      setState(() {
        _voteCount++;
      });
      widget.onVoteCountChanged(_voteCount);
    }
  }

  void _decrementVotes() {
    if (_voteCount > widget.minVotes) {
      setState(() {
        _voteCount--;
      });
      widget.onVoteCountChanged(_voteCount);
    }
  }

  int get _totalAmount => _voteCount * widget.pricePerVote;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(DesignConstants.cardBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Compteur de votes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Nombre de votes:',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                Row(
                  children: [
                    // Bouton moins
                    _buildCounterButton(
                      icon: Icons.remove,
                      onPressed: _decrementVotes,
                      isEnabled: _voteCount > widget.minVotes,
                    ),
                    const SizedBox(width: 16),
                    // Affichage du compteur
                    Container(
                      width: 60,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Text(
                        '$_voteCount',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Bouton plus
                    _buildCounterButton(
                      icon: Icons.add,
                      onPressed: _incrementVotes,
                      isEnabled: _voteCount < widget.maxVotes,
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Prix total
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total à payer:',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  Text(
                    FormatHelper.formatAmount(_totalAmount.toDouble()),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Bouton de confirmation
            VoteButton(
              onPressed: widget.onConfirmVote,
              text: 'CONFIRMER LE VOTE',
              isLoading: widget.isLoading,
              isFullWidth: true,
              backgroundColor: Colors.green,
              icon: Icons.how_to_vote,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCounterButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isEnabled,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isEnabled ? Colors.blue : Colors.grey.shade300,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: isEnabled ? onPressed : null,
        icon: Icon(
          icon,
          size: 20,
          color: isEnabled ? Colors.white : Colors.grey.shade500,
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }
}

// Bouton de vote rapide
class QuickVoteButton extends StatelessWidget {
  final int voteCount;
  final int pricePerVote;
  final VoidCallback onPressed;
  final bool isSelected;

  const QuickVoteButton({
    super.key,
    required this.voteCount,
    required this.pricePerVote,
    required this.onPressed,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final totalAmount = voteCount * pricePerVote;

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: isSelected ? Colors.blue : Colors.grey.shade700,
        side: BorderSide(
          color: isSelected ? Colors.blue : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
        backgroundColor: isSelected ? Colors.blue.shade50 : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignConstants.buttonBorderRadius),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$voteCount',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.blue : Colors.grey.shade700,
            ),
          ),
          Text(
            'votes',
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.blue : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            FormatHelper.formatAmount(totalAmount.toDouble()),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.blue : Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}

// Groupe de boutons de vote rapide
class QuickVoteButtonGroup extends StatefulWidget {
  final List<int> voteOptions;
  final int pricePerVote;
  final ValueChanged<int> onVoteCountSelected;

  const QuickVoteButtonGroup({
    super.key,
    this.voteOptions = const [1, 5, 10, 20],
    required this.pricePerVote,
    required this.onVoteCountSelected,
  });

  @override
  State<QuickVoteButtonGroup> createState() => _QuickVoteButtonGroupState();
}

class _QuickVoteButtonGroupState extends State<QuickVoteButtonGroup> {
  int? _selectedOption;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: widget.voteOptions.map((voteCount) {
        return QuickVoteButton(
          voteCount: voteCount,
          pricePerVote: widget.pricePerVote,
          isSelected: _selectedOption == voteCount,
          onPressed: () {
            setState(() {
              _selectedOption = voteCount;
            });
            widget.onVoteCountSelected(voteCount);
          },
        );
      }).toList(),
    );
  }
}

// Bouton de vote flottant
class FloatingVoteButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isVisible;
  final int? voteCount;
  final double bottomPadding;

  const FloatingVoteButton({
    super.key,
    required this.onPressed,
    this.isVisible = true,
    this.voteCount,
    this.bottomPadding = 80,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: DesignConstants.defaultAnimationDuration,
      bottom: isVisible ? bottomPadding : -100,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
          borderRadius: BorderRadius.circular(DesignConstants.cardBorderRadius),
        ),
        child: Row(
          children: [
            if (voteCount != null) ...[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$voteCount',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$voteCount vote${voteCount! > 1 ? 's' : ''} sélectionné${voteCount! > 1 ? 's' : ''}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Prêt à voter',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              const Expanded(
                child: Text(
                  'Sélectionnez un candidat pour voter',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
            const SizedBox(width: 12),
            VoteButton(
              onPressed: onPressed,
              text: 'VOTER',
              width: 100,
              isDisabled: voteCount == null,
            ),
          ],
        ),
      ),
    );
  }
}

// Bouton de vote avec animation
class AnimatedVoteButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool hasVoted;
  final String initialText;
  final String votedText;

  const AnimatedVoteButton({
    super.key,
    required this.onPressed,
    this.hasVoted = false,
    this.initialText = 'VOTER',
    this.votedText = 'DÉJÀ VOTÉ',
  });

  @override
  State<AnimatedVoteButton> createState() => _AnimatedVoteButtonState();
}

class _AnimatedVoteButtonState extends State<AnimatedVoteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: DesignConstants.fastAnimationDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onPressed();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: VoteButton(
          onPressed: widget.onPressed,
          text: widget.hasVoted ? widget.votedText : widget.initialText,
          isDisabled: widget.hasVoted,
          backgroundColor: widget.hasVoted ? Colors.grey : Colors.blue,
          icon: widget.hasVoted ? Icons.check : Icons.how_to_vote,
        ),
      ),
    );
  }
}

// Bouton de vote social (like)
class SocialVoteButton extends StatefulWidget {
  final int initialVotes;
  final bool initialVoted;
  final ValueChanged<bool> onVoteChanged;

  const SocialVoteButton({
    super.key,
    this.initialVotes = 0,
    this.initialVoted = false,
    required this.onVoteChanged,
  });

  @override
  State<SocialVoteButton> createState() => _SocialVoteButtonState();
}

class _SocialVoteButtonState extends State<SocialVoteButton> {
  late bool _isVoted;
  late int _voteCount;

  @override
  void initState() {
    super.initState();
    _isVoted = widget.initialVoted;
    _voteCount = widget.initialVotes;
  }

  void _toggleVote() {
    setState(() {
      _isVoted = !_isVoted;
      if (_isVoted) {
        _voteCount++;
      } else {
        _voteCount--;
      }
    });
    widget.onVoteChanged(_isVoted);
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: _toggleVote,
      style: OutlinedButton.styleFrom(
        foregroundColor: _isVoted ? Colors.red : Colors.grey.shade700,
        side: BorderSide(
          color: _isVoted ? Colors.red : Colors.grey.shade300,
        ),
        backgroundColor: _isVoted ? Colors.red.shade50 : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      icon: Icon(
        _isVoted ? Icons.favorite : Icons.favorite_border,
        size: 18,
        color: _isVoted ? Colors.red : Colors.grey.shade600,
      ),
      label: Text(
        FormatHelper.formatVotes(_voteCount),
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: _isVoted ? Colors.red : Colors.grey.shade700,
        ),
      ),
    );
  }
}

// Bouton de vote avec confirmation
class ConfirmationVoteButton extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final String candidateName;
  final int voteCount;
  final int totalAmount;
  final bool isLoading;

  const ConfirmationVoteButton({
    super.key,
    required this.onConfirm,
    required this.onCancel,
    required this.candidateName,
    required this.voteCount,
    required this.totalAmount,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(DesignConstants.cardBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icône de confirmation
          Icon(
            Icons.help_outline,
            size: 48,
            color: Colors.orange.shade400,
          ),
          const SizedBox(height: 16),
          
          // Titre
          Text(
            'Confirmer votre vote',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          
          // Description
          Text(
            'Vous êtes sur le point de voter pour $candidateName',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
          ),
          const SizedBox(height: 16),
          
          // Détails du vote
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$voteCount vote${voteCount > 1 ? 's' : ''}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  FormatHelper.formatAmount(totalAmount.toDouble()),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          // Boutons d'action
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onCancel,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('ANNULER'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: VoteButton(
                  onPressed: onConfirm,
                  text: 'CONFIRMER',
                  isLoading: isLoading,
                  backgroundColor: Colors.green,
                  isFullWidth: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../utils/constants.dart';

// Indicateur de chargement personnalisé
class CustomLoadingIndicator extends StatelessWidget {
  final String message;
  final double size;
  final Color color;
  final bool withBackground;

  const CustomLoadingIndicator({
    super.key,
    this.message = 'Chargement...',
    this.size = 40.0,
    this.color = Colors.blue,
    this.withBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (withBackground)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: _buildContent(),
            )
          else
            _buildContent(),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(color),
            strokeWidth: 3,
          ),
        ),
        if (message.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ],
    );
  }
}

// Indicateur de chargement avec texte personnalisé
class LoadingWithText extends StatelessWidget {
  final String text;
  final Color spinnerColor;
  final Color textColor;
  final double spacing;

  const LoadingWithText({
    super.key,
    required this.text,
    this.spinnerColor = Colors.blue,
    this.textColor = Colors.grey,
    this.spacing = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(spinnerColor),
          ),
        ),
        SizedBox(width: spacing),
        Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

// Indicateur de chargement pour les boutons
class ButtonLoadingIndicator extends StatelessWidget {
  final Color color;
  final double size;

  const ButtonLoadingIndicator({
    super.key,
    this.color = Colors.white,
    this.size = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}

// Indicateur de chargement pour les listes
class ListLoadingIndicator extends StatelessWidget {
  final bool hasMore;
  final String loadingText;
  final String noMoreText;

  const ListLoadingIndicator({
    super.key,
    this.hasMore = true,
    this.loadingText = 'Chargement...',
    this.noMoreText = 'Aucun autre élément',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: hasMore
            ? LoadingWithText(text: loadingText)
            : Text(
                noMoreText,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
      ),
    );
  }
}

// Indicateur de chargement avec pourcentage
class PercentageLoadingIndicator extends StatelessWidget {
  final double percentage;
  final String message;
  final Color color;

  const PercentageLoadingIndicator({
    super.key,
    required this.percentage,
    this.message = 'Chargement...',
    this.color = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(
                value: percentage / 100,
                strokeWidth: 4,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                backgroundColor: Colors.grey.shade200,
              ),
            ),
            Text(
              '${percentage.toInt()}%',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          message,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

// Indicateur de chargement skeleton
class SkeletonLoading extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final Color baseColor;
  final Color highlightColor;

  const SkeletonLoading({
    super.key,
    this.width = double.infinity,
    this.height = 20,
    this.borderRadius = 4,
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFF5F5F5),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: ShaderMask(
          shaderCallback: (rect) {
            return LinearGradient(
              colors: [baseColor, highlightColor, baseColor],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment.topLeft,
              end: Alignment.topRight,
            ).createShader(rect);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
        ),
      ),
    );
  }
}

// Liste de squelettes pour le chargement
class SkeletonList extends StatelessWidget {
  final int itemCount;
  final bool hasLeading;
  final bool hasTrailing;

  const SkeletonList({
    super.key,
    this.itemCount = 5,
    this.hasLeading = true,
    this.hasTrailing = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: SkeletonItem(
            hasLeading: hasLeading,
            hasTrailing: hasTrailing,
          ),
        );
      },
    );
  }
}

// Élément de squelette pour les listes
class SkeletonItem extends StatelessWidget {
  final bool hasLeading;
  final bool hasTrailing;

  const SkeletonItem({
    super.key,
    this.hasLeading = true,
    this.hasTrailing = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (hasLeading)
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: SkeletonLoading(
              width: 50,
              height: 50,
              borderRadius: 25,
            ),
          ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonLoading(
                width: double.infinity,
                height: 16,
                borderRadius: 4,
              ),
              const SizedBox(height: 8),
              SkeletonLoading(
                width: 120,
                height: 12,
                borderRadius: 4,
              ),
            ],
          ),
        ),
        if (hasTrailing)
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: SkeletonLoading(
              width: 60,
              height: 20,
              borderRadius: 10,
            ),
          ),
      ],
    );
  }
}

// Indicateur de chargement pour les images
class ImageLoadingIndicator extends StatelessWidget {
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Color backgroundColor;

  const ImageLoadingIndicator({
    super.key,
    this.width,
    this.height,
    this.fit,
    this.backgroundColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: backgroundColor.withOpacity(0.1),
      child: const Center(
        child: CustomLoadingIndicator(
          size: 30,
          message: '',
        ),
      ),
    );
  }
}

// Indicateur de chargement pour les pages pleines
class FullPageLoading extends StatelessWidget {
  final String message;
  final Color backgroundColor;

  const FullPageLoading({
    super.key,
    this.message = 'Chargement...',
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CustomLoadingIndicator(
              size: 50,
              message: '',
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Indicateur de chargement avec animation personnalisée
class AnimatedLoadingIndicator extends StatefulWidget {
  final String message;
  final List<Color> colors;
  final Duration animationDuration;

  const AnimatedLoadingIndicator({
    super.key,
    this.message = 'Chargement...',
    this.colors = const [Colors.blue, Colors.green, Colors.orange],
    this.animationDuration = const Duration(milliseconds: 1500),
  });

  @override
  State<AnimatedLoadingIndicator> createState() => _AnimatedLoadingIndicatorState();
}

class _AnimatedLoadingIndicatorState extends State<AnimatedLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: widget.colors.first,
      end: widget.colors.length > 1 ? widget.colors[1] : widget.colors.first,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _colorAnimation,
          builder: (context, child) {
            return Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _colorAnimation.value,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.hourglass_bottom,
                color: Colors.white,
                size: 20,
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        Text(
          widget.message,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
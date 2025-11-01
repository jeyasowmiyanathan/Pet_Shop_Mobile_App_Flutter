import 'package:flutter/material.dart';

/// A vibrant, playful background suitable for a pet-shop storefront.
///
/// Use it as a wrapper for screen bodies:
/// GradientBackground(child: yourContent)
class GradientBackground extends StatelessWidget {
  final Widget? child;
  /// Optional local asset path for a background image (preferred if provided).
  final String? backgroundAsset;
  /// Optional network image URL for a background image. Used if [backgroundAsset] is null.
  final String? backgroundImageUrl;
  /// When true, render only the background image (with a subtle overlay) and
  /// don't draw decorative blobs/patterns. Use this for clean pet-photo
  /// backgrounds.
  final bool imageOnly;

  const GradientBackground({
    super.key,
    this.child,
    this.backgroundAsset,
    this.backgroundImageUrl,
    this.imageOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base gradient
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF8EE3FF), // bright sky blue
                  Color(0xFF9DF7B8), // mint green
                  Color(0xFFFFF59D), // soft yellow
                ],
                stops: [0.0, 0.55, 1.0],
              ),
            ),
          ),
        ),

        // Background photo (asset preferred, network fallback)
        if (backgroundAsset != null || backgroundImageUrl != null)
          Positioned.fill(
            child: Opacity(
              opacity: 1.0,
              child: backgroundAsset != null
                  ? Image.asset(
                      backgroundAsset!,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      backgroundImageUrl!,
                      fit: BoxFit.cover,
                    ),
            ),
          ),

        // A subtle overlay so content remains readable on top of photos
        if (backgroundAsset != null || backgroundImageUrl != null)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(imageOnly ? 0.22 : 0.12),
            ),
          ),

        // Decorative layers (only when not in imageOnly mode)
        if (!imageOnly) ...[
          // Decorative blobs (soft, colorful)
          Positioned(
            left: -80,
            top: -60,
            child: _DecorativeBlob(
              width: 300,
              height: 300,
              colors: const [Color(0xFFFFA8C5), Color(0xFFFFE29A)],
              rotation: -0.3,
              opacity: 0.22,
            ),
          ),
          Positioned(
            right: -100,
            top: 40,
            child: _DecorativeBlob(
              width: 260,
              height: 260,
              colors: const [Color(0xFF6EC6FF), Color(0xFF8AE6C1)],
              rotation: 0.4,
              opacity: 0.18,
            ),
          ),
          Positioned(
            left: 40,
            bottom: -60,
            child: _DecorativeBlob(
              width: 220,
              height: 220,
              colors: const [Color(0xFFFFF59D), Color(0xFFFFC48C)],
              rotation: 0.1,
              opacity: 0.14,
            ),
          ),

          // Paw-print pattern (subtle)
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _PawPatternPainter(),
              ),
            ),
          ),

          // Playful pet silhouettes using simple icons (decorative)
          Positioned(
            right: 24,
            bottom: 80,
            child: Opacity(
              opacity: 0.14,
              child: Icon(Icons.pets, size: 110, color: Colors.white),
            ),
          ),
          Positioned(
            left: 18,
            top: 120,
            child: Opacity(
              opacity: 0.12,
              child: Transform.rotate(
                angle: -0.2,
                child: Icon(Icons.flight, size: 92, color: Colors.white),
              ),
            ),
          ),
        ],

        // Leave the child content on top
        if (child != null) Positioned.fill(child: child!),
      ],
    );
  }
}

class _DecorativeBlob extends StatelessWidget {
  final double width;
  final double height;
  final List<Color> colors;
  final double rotation;
  final double opacity;

  const _DecorativeBlob({
    required this.width,
    required this.height,
    required this.colors,
    this.rotation = 0.0,
    this.opacity = 0.2,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation,
      child: Opacity(
        opacity: opacity,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: colors,
              stops: const [0.0, 1.0],
            ),
            borderRadius: BorderRadius.circular(width * 0.45),
            boxShadow: [
              BoxShadow(
                color: colors.last.withOpacity(0.12),
                blurRadius: 24,
                spreadRadius: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PawPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.03);

    // Draw repeating paw clusters across the canvas
    const pawSpacingX = 120.0;
    const pawSpacingY = 100.0;
    for (double y = 0; y < size.height + pawSpacingY; y += pawSpacingY) {
      for (double x = 0; x < size.width + pawSpacingX; x += pawSpacingX) {
        _drawPaw(canvas, Offset(x - 30, y - 10), paint);
      }
    }
  }

  void _drawPaw(Canvas canvas, Offset offset, Paint paint) {
    // Four small toe circles and one big pad circle
    final padCenter = offset.translate(20, 18);
    canvas.drawCircle(padCenter, 10, paint);
    canvas.drawCircle(offset.translate(6, 6), 4, paint);
    canvas.drawCircle(offset.translate(12, -4), 4, paint);
    canvas.drawCircle(offset.translate(28, -4), 4, paint);
    canvas.drawCircle(offset.translate(34, 6), 4, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

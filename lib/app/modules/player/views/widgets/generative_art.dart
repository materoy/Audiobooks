import 'dart:math' as math;
import 'package:flutter/material.dart';

class Particle {
  double size;
  double radius;
  double startingTheta;
  Color color;

  Particle({
    required this.size,
    required this.radius,
    required this.startingTheta,
    required this.color,
  });
}

class GenerativeArt extends StatefulWidget {
  @override
  _GenerativeArtState createState() => _GenerativeArtState();
}

class _GenerativeArtState extends State<GenerativeArt>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  late final Tween<double> _rotationTween;
  List<Particle> particles = [];

  void generateListOfParticles() {
    const int numberOfParticles = 100;

    for (int i = 0; i < numberOfParticles; i++) {
      final double randomSize = math.Random().nextDouble() * 20;

      final int randomR = math.Random().nextInt(256);
      final int randomG = math.Random().nextInt(256);
      final int randomB = math.Random().nextInt(256);

      final Color randomColor = Color.fromARGB(255, randomR, randomG, randomB);

      final double randomRadius = math.Random().nextDouble() * 200;
      final double randomTheta = math.Random().nextDouble() * (2 * math.pi);

      final Particle particle = Particle(
        size: randomSize,
        radius: randomRadius,
        startingTheta: randomTheta,
        color: randomColor,
      );
      particles.add(particle);
    }
  }

  @override
  void initState() {
    super.initState();

    generateListOfParticles();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );

    _rotationTween = Tween(begin: 0, end: 2 * math.pi);

    animation = _rotationTween.animate(controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });

    controller.forward();
  }

  @override
  void dispose() {
    animation.removeListener(() {});
    animation.removeStatusListener((status) {});
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MyPainter(
        particles: particles,
        theta: animation.value,
      ),
      child: Container(),
    );
  }
}

class MyPainter extends CustomPainter {
  final List<Particle> particles;
  final double theta;

  MyPainter({required this.particles, required this.theta});

  @override
  void paint(Canvas canvas, Size size) {
    // generative art
    // double radius = 200.0;

    // paint brush
    var paint = Paint()..strokeWidth = 5;

    /// Calulation:
    /// ----------
    /// x = rcos(theta)
    /// y = rsin(theta)
    ///
    /// vary `theta` to generate different points
    ///

    particles.forEach((particle) {
      double randomTheta = particle.startingTheta + theta;
      double radius = particle.radius;

      double dx = radius * theta * math.cos(randomTheta) + size.width / 2;
      double dy = radius * theta * math.sin(randomTheta) + size.height / 2;

      Offset position = Offset(dx, dy);

      paint.color = particle.color;

      canvas.drawCircle(position, particle.size, paint);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

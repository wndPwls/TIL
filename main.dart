import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const DiceApp());
}

class DiceApp extends StatelessWidget {
  const DiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Premium Dice Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1A1A2E),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE94560),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const DicePage(),
    );
  }
}

class DicePage extends StatefulWidget {
  const DicePage({super.key});

  @override
  State<DicePage> createState() => _DicePageState();
}

class _DicePageState extends State<DicePage>
    with SingleTickerProviderStateMixin {
  int leftDice = 1;
  int rightDice = 1;
  late AnimationController _controller;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _controller.addListener(() {
      if (_controller.status == AnimationStatus.forward) {
        setState(() {
          // Scramble numbers while animating for effect
          leftDice = _random.nextInt(6) + 1;
          rightDice = _random.nextInt(6) + 1;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _rollDice() {
    if (_controller.isAnimating) return;
    _controller.forward().then((_) => _controller.reverse());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'LUCKY DICE',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Dice Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _rollDice,
                      child: ScaleTransition(
                        scale: Tween<double>(begin: 1.0, end: 0.9).animate(
                          CurvedAnimation(
                            parent: _controller,
                            curve: const Interval(
                              0.0,
                              0.5,
                              curve: Curves.easeOut,
                            ),
                          ),
                        ),
                        child: DiceFace(value: leftDice),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: GestureDetector(
                      onTap: _rollDice,
                      child: ScaleTransition(
                        scale: Tween<double>(begin: 1.0, end: 0.9).animate(
                          CurvedAnimation(
                            parent: _controller,
                            curve: const Interval(
                              0.0,
                              0.5,
                              curve: Curves.easeOut,
                            ),
                          ),
                        ),
                        child: DiceFace(value: rightDice),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 60),
            // Roll Button
            SizedBox(
              width: 200,
              height: 60,
              child: ElevatedButton(
                onPressed: _rollDice,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE94560),
                  foregroundColor: Colors.white,
                  elevation: 10,
                  shadowColor: const Color(0xFFE94560).withValues(alpha: 0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'ROLL DICE',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Total: ${leftDice + rightDice}',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white.withValues(alpha: 0.7),
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DiceFace extends StatelessWidget {
  final int value;

  const DiceFace({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(5, 5),
            ),
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.1),
              blurRadius: 5,
              offset: const Offset(-2, -2),
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.grey[100]!, Colors.grey[300]!],
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: CustomPaint(
          painter: DicePainter(value, const Color(0xFF16213E)),
        ),
      ),
    );
  }
}

class DicePainter extends CustomPainter {
  final int value;
  final Color dotColor;

  DicePainter(this.value, this.dotColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;

    final double dotSize = size.width / 5;
    final double center = size.width / 2;
    final double left = size.width / 4;
    final double right = size.width * 3 / 4;
    final double top = size.height / 4;
    final double bottom = size.height * 3 / 4;

    final List<Offset> dots = [];

    switch (value) {
      case 1:
        dots.add(Offset(center, center));
        break;
      case 2:
        dots.add(Offset(left, top));
        dots.add(Offset(right, bottom));
        break;
      case 3:
        dots.add(Offset(left, top));
        dots.add(Offset(center, center));
        dots.add(Offset(right, bottom));
        break;
      case 4:
        dots.add(Offset(left, top));
        dots.add(Offset(right, top));
        dots.add(Offset(left, bottom));
        dots.add(Offset(right, bottom));
        break;
      case 5:
        dots.add(Offset(left, top));
        dots.add(Offset(right, top));
        dots.add(Offset(center, center));
        dots.add(Offset(left, bottom));
        dots.add(Offset(right, bottom));
        break;
      case 6:
        dots.add(Offset(left, top));
        dots.add(Offset(right, top));
        dots.add(Offset(left, center));
        dots.add(Offset(right, center));
        dots.add(Offset(left, bottom));
        dots.add(Offset(right, bottom));
        break;
    }

    for (final dot in dots) {
      canvas.drawCircle(dot, dotSize / 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant DicePainter oldDelegate) {
    return oldDelegate.value != value || oldDelegate.dotColor != dotColor;
  }
}

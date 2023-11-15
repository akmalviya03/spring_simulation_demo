import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SpringSimulationDemo(),
    );
  }
}

class SpringSimulationDemo extends StatefulWidget {
  const SpringSimulationDemo({Key? key}) : super(key: key);

  @override
  State<SpringSimulationDemo> createState() => _SpringSimulationDemoState();
}

class _SpringSimulationDemoState extends State<SpringSimulationDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late double height;
  late double width;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController.unbounded(
      vsync: this,
    );
    _controller.addListener(() {
      if (kDebugMode) {
        print(_controller.value);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    height = (MediaQuery.of(context).size.height -
        (MediaQuery.maybeViewPaddingOf(context)?.vertical ?? 0));
    width = MediaQuery.sizeOf(context).width;
    if (kDebugMode) {
      print(MediaQuery.of(context).size);
      print(MediaQuery.maybeViewPaddingOf(context)?.vertical);
      print(MediaQuery.of(context).devicePixelRatio);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: CustomPaint(
            painter: BoxPainter(animation: _controller),
            size: Size(width, height),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        isExtended: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () {

          //Starting position defines whether the spring is compressed or stretched.
          //If initial position is greater than final position then it will be considered as stretched
          //Starting position defines the location from where string will be released.

          //Initial velocity of the spring we will release it.

          //Spring constant
          //Stiffness defines how much this spring resists deformation.
          //It is defined as the force required to compress or stretch the spring by a certain distance
          // k(stiffness) = F/X

          //Damping coefficient
          //Dampness define how the spring oscillation will decay
          //In simple words, damping controls oscillation
          //Higher dampness means less oscillation


          _controller.animateWith(SpringSimulation(
            const SpringDescription(
              mass: 10,
              stiffness: 10,
              damping: 0.5,
            ),
            0,
            height / 2,
            100,
          ));
        },
        label: const Text('Play Simulation'),
      ),
    );
  }
}

class BoxPainter extends CustomPainter {
  final Animation animation;
  BoxPainter({required this.animation}) : super(repaint: animation);
  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(0, 10);
    canvas.drawRect(
        Rect.fromCenter(
            center: Offset(size.width / 2, animation.value),
            width: 20,
            height: 20),
        Paint()..color = Colors.green);
  }

  @override
  bool shouldRepaint(BoxPainter oldDelegate) {
    return true;
  }
}

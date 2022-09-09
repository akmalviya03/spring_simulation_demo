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
  late Animation<Alignment> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController.unbounded(vsync: this);
    _animation = _controller.drive(
      AlignmentTween(
        begin: const Alignment(
          0,
          0,
        ),
        end: const Alignment(
          0,
          1,
        ),
      ),
    );

    _controller.addListener(() {
      if (kDebugMode) {
        print("Controller ${_controller.value}");
        print("Animation ${_animation.value}");
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: AnimatedBuilder(
                    animation: _animation,
                    child: Container(
                      color: Colors.black,
                      height: 10,
                      width: 10,
                    ),
                    builder: (context, child) {
                      return Align(
                        alignment: _animation.value,
                        child: child,
                      );
                    }),
              ),
              ElevatedButton(
                  onPressed: () {
                    _controller.animateWith(SpringSimulation(
                      //In Spring description we define actual properties of a spring
                      const SpringDescription(
                        // Lower the damping coefficient better it will bounce
                        // Damping means restraining oscillatory motion
                        damping: 1,
                        // More stiffness means spring will less deform
                        // Springs having higher stiffness are more difficult to stretch
                        stiffness: 1,
                        //Mass Attached to the spring
                        mass: 1,
                      ),
                      //When initial and Final Position is same then spring is in equilibrium
                      //Initial position
                      0,
                      //Final position
                      1,
                      // Negative means spring will stretch itself from the starting position.
                      // Positive means spring will stretch itself from the ending potion.
                      0,
                    ));
                  },
                  child: const Text('Play Spring Simulation'))
            ],
          ),
        ),
      ),
    );
  }
}

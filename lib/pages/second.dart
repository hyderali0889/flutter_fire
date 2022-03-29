import 'package:flutter/material.dart';

class Second extends StatefulWidget {
  const Second({Key? key}) : super(key: key);

  @override
  State<Second> createState() => _SecondState();
}

class _SecondState extends State<Second> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation anim;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));
    anim = Tween(begin: 0.0, end: 10.0).animate(_controller);
    _controller.addListener(() {
      setState(() {
        print("${anim.value}");
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Container(
            child: Transform.rotate(
                angle: anim.value, child: const Text("Second PAge")),
          ),
        ),
        TextButton(onPressed: startanim, child: const Text("Start Animation"))
      ],
    );
  }

  void startanim() {
    _controller.forward();
  }
}

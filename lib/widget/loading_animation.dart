import 'package:flutter/material.dart';

class LoadingAnimation extends StatefulWidget {
  double width,height;

  LoadingAnimation({super.key,this.height=100,this.width=100});

  @override
  State<LoadingAnimation> createState() => _LoadingAnimationState(width: width,height: height);
}

class _LoadingAnimationState extends State<LoadingAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<AlignmentGeometry> _alignment;
  double width,height;

  _LoadingAnimationState({required this.width,required this.height});

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat();
    _alignment = Tween<AlignmentGeometry>(
            begin: Alignment.centerLeft, end: Alignment.centerRight)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Align(
      child: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
            color: Color.fromARGB(255, 245, 236, 236),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: AlignTransition(
          alignment: _alignment,
          child: Container(
            width: 30,
            height: double.infinity,
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
              Color.fromARGB(255, 245, 236, 236),
              Color.fromARGB(255, 245, 236, 236),
              Color.fromARGB(172, 255, 254, 230),
              Color.fromARGB(255, 255, 254, 230),
              Color.fromARGB(134, 255, 254, 230),
              Color.fromARGB(255, 245, 236, 236),
              Color.fromARGB(255, 245, 236, 236),
            ])),
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }
}

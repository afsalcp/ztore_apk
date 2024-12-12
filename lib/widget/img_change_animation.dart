import 'package:flutter/material.dart';

class ImgChageAnimation extends StatefulWidget {
  const ImgChageAnimation(Key key,{ required this.img}):super(key: key);

  @override
  State<ImgChageAnimation> createState() => ImgChageAnimationState(img,);
  final String img;
}

class ImgChageAnimationState extends State<ImgChageAnimation> with SingleTickerProviderStateMixin {
  ImgChageAnimationState(this.img);

  String img;

  late final AnimationController _controller=AnimationController(vsync: this,duration: const Duration(milliseconds: 300))..forward();
  late final Animation<double> scaling;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    scaling=Tween<double>(begin: .7,end: 1).animate(_controller);
  }

  void changeImage(String img){
    print('hello there');
    setState(() {
      this.img=img;
      _controller.reset();
      _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return ScaleTransition(
      scale: scaling,
      child: Container(
        margin: const EdgeInsets.all(10),
        width: screen.width * .65,
        height: 300,
        decoration: BoxDecoration(
            image: DecorationImage(image: NetworkImage(img), fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }
}

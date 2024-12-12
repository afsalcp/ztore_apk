import 'dart:ui';

import 'package:flutter/material.dart';

class CardSm extends StatelessWidget {
  CardSm({super.key, required this.cards});

  List cards;

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (ctx, i) {
          return Container(
            width: 140,
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                  image: NetworkImage(cards[i]['image']), fit: BoxFit.cover),
            ),
            alignment: Alignment.bottomCenter,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Container(
                  width: 140,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(161, 192, 182, 182),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8)),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    cards[i]['name'],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (ctx, _) => const SizedBox(
          width: 10,
        ),
        itemCount: cards.length,
      ),
    );
  }
}

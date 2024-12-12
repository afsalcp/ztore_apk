import 'package:ecommerce/consts/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CardL extends StatelessWidget {
  const CardL({super.key,required this.cards});

  final List cards;

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Container(
                      margin: const EdgeInsets.only(top: 20),
                      width: screen.width * .9,
                      height: 350,
                      child: ListView.separated(
                        itemCount: cards.length,
                        itemBuilder: (ctx, i) {
                          return InkWell(
                            onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
                                return cards[i]['next'];
                              }));
                            },
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: 200,
                                height: 300,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color:Colors.white,
                                    boxShadow: const [
                                      BoxShadow(
                                        offset: Offset(5,5),
                                        color: Color.fromARGB(255, 110, 100, 100),
                                        spreadRadius: 2,
                                        blurRadius: 10
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(8)),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 220,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          cards[i]['image'],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Column(
                                          children: [
                                            SizedBox(
                                              width: 120,
                                              child: Text(
                                                cards[i]['title'],
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: "Normal",
                                                  fontWeight: FontWeight.bold,
                                                  
                                                ),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              width: 120,
                                              child: Text("\$ ${cards[i]['price']}",textAlign: TextAlign.left,style: const TextStyle(
                                                color: Color.fromARGB(255, 99, 97, 97)
                                              ),),
                                            )
                                          ],
                                        ),
                                        Container(
                                         width: 60,
                                         height: 60,
                                         alignment: Alignment.bottomRight,
                                          child: const SizedBox(
                                            width: 50,
                                            height: 50,
                                            child: IconButton(onPressed: null, icon: Icon(Icons.favorite),style: ButtonStyle(
                                              backgroundColor: MaterialStatePropertyAll(primary),
                                              iconColor: MaterialStatePropertyAll(Colors.white)
                                            ),),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (ctx, i) => const SizedBox(
                          width: 10,
                        ),
                        scrollDirection: Axis.horizontal,
                      ),
                    );
  }
}
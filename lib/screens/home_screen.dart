import 'dart:math';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:ecommerce/config/db.dart';
import 'package:ecommerce/config/reqs.dart';
import 'package:ecommerce/consts/colors.dart';
import 'package:ecommerce/screens/cart_screen.dart';
import 'package:ecommerce/screens/product_screen.dart';
import 'package:ecommerce/screens/profile_screen.dart';
import 'package:ecommerce/widget/card_l.dart';
import 'package:ecommerce/widget/card_sm.dart';
import 'package:ecommerce/widget/loading_animation.dart';
import 'package:ecommerce/widget/prompt.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key}) {
    slCtgr = categorie[Random().nextInt(5)];

    dio
        .get(
            "https://api.escuelajs.co/api/v1/categories/${slCtgr['id']}/products")
        .then((Response res) {
      cards.value = res.data.map((item) {
        return {
          "title": item['title'],
          'price': item['price'].toString(),
          'image': item['images'][0].replaceAll(RegExp(r'\[|\]|\"'), ""),
          'next':ProductScreen(id: item['id'])
        };
      }).toList();

      db.collection('config').doc('1').get().then((value)async{
        if(!value!.containsKey('developer_notice')){
          Prompt.show(msg: "The products listed here is only for showcase and you can't buy anything from this app \nApp developer :  Muhammed Afsal Cp",cancel: false);
          value['developer_notice']=true;
          print(value);
          await db.collection('config').doc('1').set(value);
        }
      });
      
      
    });
  }

  ValueNotifier cards = ValueNotifier(null);
  late Map slCtgr;
  List<Map> categorie = [
    {
      "id": 1,
      "name": "Clothes",
      "image": "https://i.imgur.com/QkIa5tT.jpeg",
    },
    {
      "id": 2,
      "name": "Electronics",
      "image": "https://i.imgur.com/ZANVnHE.jpeg",
    },
    {
      "id": 3,
      "name": "Furniture",
      "image": "https://i.imgur.com/Qphac99.jpeg",
    },
    {
      "id": 4,
      "name": "Shoes",
      "image": "https://i.imgur.com/qNOjJje.jpeg",
    },
    {
      "id": 5,
      "name": "Miscellaneous",
      "image": "https://i.imgur.com/BG8J0Fj.jpg",
    }
  ];

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: light_grey,
      drawer: SafeArea(
        child: Container(
          width: screen.width * .7,
          decoration: const BoxDecoration(
              color: light_grey,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8))),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              children: [
                const SizedBox(
                  height: 140,
                ),

                ValueListenableBuilder(
                    valueListenable: cards,
                    builder: (context, cur, _) {
                      if (cur == null) {
                        return LoadingAnimation(
                          width: screen.width * .9,
                          height: 400,
                        );
                      }
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 30, right: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "New In ${slCtgr['name']}",
                                  style: const TextStyle(
                                      fontFamily: "Normal",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22),
                                ),
                                const Text(
                                  "See all",
                                  style: TextStyle(
                                      color: secondary_shade,
                                      fontFamily: "Normal"),
                                )
                              ],
                            ),
                          ),
                          CardL(cards: cur),
                        ],
                      );
                    }),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  width: screen.width - 30,
                  height: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          "Categories",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Normal",
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      CardSm(cards: categorie)
                      
                    ],
                  ),
                )
                // LoadingAnimation(
                //   height: 300,
                //   width: screen.width * .9,
                // )
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 30),
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: IconButton(
                      onPressed: null,
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.white),
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))))),
                    ),
                  ),
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: IconButton(
                      onPressed: null,
                      icon: Icon(
                        Icons.menu,
                        color: Colors.black,
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.white),
                        shape: MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Prompt()
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: light_grey,
        selectedItemColor: primary,
        unselectedItemColor: secondary,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (int i){
          Widget? selected;
          switch(i){
            case 0:
              selected=HomeScreen();break;
            case 1:
              selected= CartScreen();break;
            case 3:
            selected=const ProfileScreen();break;
          }

          if(selected==null)return;

          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx){
            return selected!;
          }));
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.widgets), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.local_mall,
              ),
              label: "Cart"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
              ),
              label: "Liked"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

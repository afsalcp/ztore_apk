import 'package:dio/dio.dart';
import 'package:ecommerce/config/db.dart';
import 'package:ecommerce/config/reqs.dart';
import 'package:ecommerce/consts/colors.dart';
import 'package:ecommerce/screens/home_screen.dart';
import 'package:ecommerce/screens/login_page.dart';
import 'package:ecommerce/widget/loading_animation.dart';
import 'package:ecommerce/widget/prompt.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  CartScreen({super.key}) {
    // db.collection("cart").delete();
    db.collection('cart').doc('cart').get().then((cart) async {
      if (cart == null) {
        products.value = [];
      }
      List prods = [];
      for (int item in cart!['items']) {
        Response prod =
            await dio.get("https://api.escuelajs.co/api/v1/products/$item");

        Map itemData =
            (await db.collection('cart').doc(item.toString()).get())!;
        prod.data['item_count'] = itemData['item_count'];
        prods.add(prod.data);
      }
      userData.value = await db.collection('user').doc("1").get();
      print(userData);
      products.value = prods;
      // cart!["items"].forEach((item)async{
      //   Response prod=await dio.get("https://api.escuelajs.co/api/v1/products/$item");
      //   pro
      // });
    });
  }

  ValueNotifier<List?> products = ValueNotifier(null);
  ValueNotifier<bool> delivery = ValueNotifier(true);
  ValueNotifier<Map?> userData = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: light_grey,
      appBar: AppBar(
        backgroundColor: light_grey,
        title: const Align(
          alignment: Alignment.center,
          child: Text(
            'My Cart',
            style: TextStyle(fontSize: 18),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
          child: Stack(
        children: [
          ValueListenableBuilder(
              valueListenable: products,
              builder: (context, prods, _) {
                if (prods == null) {
                  return ListView(
                    children: [
                      LoadingAnimation(
                        width: screen.width - 40,
                        height: (screen.height / 2) - 50,
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      LoadingAnimation(
                        width: screen.width - 40,
                        height: (screen.height / 2) - 50,
                      )
                    ],
                  );
                }
                if (prods.isEmpty) {
                  return Container(
                    alignment: Alignment.center,
                    child: const Text(
                      "Nothing left in your cart! 🙁",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  );
                }
                return ListView(
                  children: [
                    Container(
                      width: screen.width,
                      height: screen.height * .5,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                      margin: const EdgeInsets.all(10),
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${prods.length} items",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Column(
                            children: [
                              SizedBox(
                                height: (screen.height * .5) - 120,
                                child: ListView.separated(
                                    itemBuilder: (ctx, i) {
                                      return SizedBox(
                                        width: double.infinity,
                                        height: 120,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 70,
                                              height: 70,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          prods[i]['images']
                                                              [0])),
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                            ),
                                            Container(
                                              width: (screen.width - 110) * .6,
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    prods[i]['title'],
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "\$ ${prods[i]['price']}",
                                                      textAlign: TextAlign.left,
                                                      style: const TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              103,
                                                              104,
                                                              112),
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: (screen.width - 110) * .4,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  IconButton(
                                                      onPressed: () async {
                                                        // products.value=products.value!.map((e)async{
                                                        //   if(e['id']==prods[i]['id']){
                                                        //     e['item_count']+=1;
                                                        //     Map<String,dynamic> item= (await db.collection('cart').doc(e['id'].toString()).get())!;
                                                        //     item['item_count']=e['item_count'];
                                                        //     print(item);
                                                        //     await db.collection('cart').doc(e['id'].toString()).set(item);
                                                        //   }
                                                        //   return e;
                                                        // }).toList();
                                                        List items = [];
                                                        for (Map e in products
                                                            .value!) {
                                                          if (e['id'] ==
                                                              prods[i]['id']) {
                                                            e['item_count'] +=
                                                                1;

                                                            Map<String, dynamic>
                                                                item = (await db
                                                                    .collection(
                                                                        'cart')
                                                                    .doc(e['id']
                                                                        .toString())
                                                                    .get())!;
                                                            item['item_count'] =
                                                                e['item_count'];
                                                            print(item);
                                                            await db
                                                                .collection(
                                                                    'cart')
                                                                .doc(e['id']
                                                                    .toString())
                                                                .set(item);
                                                          }
                                                          items.add(e);
                                                        }
                                                        products.value = items;
                                                      },
                                                      icon: const Icon(
                                                        Icons
                                                            .add_circle_outline,
                                                        color: primary,
                                                      )),
                                                  Text(
                                                    "${prods[i]['item_count']}",
                                                    style: const TextStyle(
                                                        color: primary,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  IconButton(
                                                      onPressed: () async {
                                                        List items = [];

                                                        for (Map e in products
                                                            .value!) {
                                                          if (e['id'] ==
                                                              prods[i]['id']) {
                                                            if (e['item_count'] ==
                                                                1) {
                                                              if (!(await Prompt.show(
                                                                  msg:
                                                                      "Are you sure want to remove this item from cart",
                                                                  ok: 'yes',
                                                                  cancel:
                                                                      'no'))) {
                                                                items.add(e);
                                                                continue;
                                                              }
                                                              Map<String,
                                                                      dynamic>
                                                                  cart =
                                                                  (await db
                                                                      .collection(
                                                                          'cart')
                                                                      .doc(
                                                                          'cart')
                                                                      .get())!;
                                                              cart['items']
                                                                  .remove(
                                                                      e['id']);
                                                              await db
                                                                  .collection(
                                                                      'cart')
                                                                  .doc(e['id']
                                                                      .toString())
                                                                  .set(cart);
                                                              await db
                                                                  .collection(
                                                                      'cart')
                                                                  .doc(e['id']
                                                                      .toString())
                                                                  .delete();
                                                              continue;
                                                            }
                                                            e['item_count'] -=
                                                                1;
                                                            Map<String, dynamic>
                                                                item = (await db
                                                                    .collection(
                                                                        'cart')
                                                                    .doc(e['id']
                                                                        .toString())
                                                                    .get())!;
                                                            item['item_count'] -=
                                                                1;
                                                            await db
                                                                .collection(
                                                                    'item_count')
                                                                .doc(e['id']
                                                                    .toString())
                                                                .set(item);
                                                          }
                                                          items.add(e);
                                                        }
                                                        products.value = items;
                                                      },
                                                      icon: const Icon(
                                                        Icons
                                                            .remove_circle_outline_rounded,
                                                        color: primary,
                                                      )),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                    separatorBuilder: (ctx, _) =>
                                        const SizedBox(
                                          height: 10,
                                        ),
                                    itemCount: prods.length),
                              ),
                            ],
                          ),
                          Container(
                            width: double.infinity,
                            height: 60,
                            alignment: Alignment.center,
                            child: TextButton(
                              onPressed: () async {
                                if (!(await Prompt.show(
                                    msg: "Are you sure want to clear the cart",
                                    ok: "yes",
                                    cancel: 'no'))) return;

                                (await db.collection('cart').delete());
                                products.value = [];
                              },
                              style: ButtonStyle(
                                  shape: MaterialStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8))),
                                  side: const MaterialStatePropertyAll(
                                      BorderSide(color: primary))),
                              child: const Text(
                                'clear cart',
                                style: TextStyle(
                                    color: primary,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    ValueListenableBuilder(
                        valueListenable: delivery,
                        builder: (context, delivery, _) {
                          return Container(
                            width: double.infinity,
                            height: screen.height * .5,
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: 240,
                                  height: 35,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: primary),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () =>
                                            this.delivery.value = false,
                                        child: Container(
                                          width: 120,
                                          alignment: Alignment.center,
                                          color: delivery
                                              ? Colors.transparent
                                              : primary,
                                          child: Text(
                                            'Pickup',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: delivery
                                                    ? primary
                                                    : Colors.white),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () => this.delivery.value = true,
                                        child: Container(
                                          width: 118,
                                          alignment: Alignment.center,
                                          color: !delivery
                                              ? Colors.transparent
                                              : primary,
                                          child: Text(
                                            'Delivery',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: !delivery
                                                    ? primary
                                                    : Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ValueListenableBuilder(
                                    valueListenable: userData,
                                    builder: (ctx, userData, _) {
                                      List<Widget> colChilds = [];

                                      if (userData == null ||
                                          delivery &&
                                              userData['name'] == null ||
                                          userData['place'] == null) {
                                        return Container(
                                          height: 250,
                                          alignment: Alignment.center,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Text(
                                                  "You need to give us your adreess for delivery"),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              SizedBox(
                                                  height: 45,
                                                  child: ElevatedButton(
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                            const MaterialStatePropertyAll(
                                                                secondary),
                                                        shape:
                                                            MaterialStatePropertyAll(
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder: (ctx) {
                                                          return LoginPage(
                                                            nextPage: true,
                                                          );
                                                        })).then((value) async =>
                                                            this
                                                                    .userData
                                                                    .value =
                                                                await db
                                                                    .collection(
                                                                        'user')
                                                                    .doc('1')
                                                                    .get());
                                                      },
                                                      child: const Text(
                                                        'set adress',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )))
                                            ],
                                          ),
                                        );
                                      }
                                      List<Widget> billingData = [];

                                      if (delivery) {
                                        billingData.add(Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              "Delivery Adress",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                          builder: (ctx) =>
                                                              LoginPage(
                                                                nextPage: true,
                                                              )))
                                                      .then((value) async =>
                                                          this.userData.value =
                                                              await db
                                                                  .collection(
                                                                      'user')
                                                                  .doc('1')
                                                                  .get());
                                                },
                                                child: const Text(
                                                  "Edit",
                                                  style: TextStyle(
                                                      color: secondary),
                                                ))
                                          ],
                                        ));
                                        billingData.add(Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "${userData['name']}, ${userData['place']}",
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            )));
                                        DateTime delTime = DateTime
                                            .fromMillisecondsSinceEpoch(DateTime
                                                        .now()
                                                    .millisecondsSinceEpoch +
                                                (60 * 60 * 24 * 1000 * 5));
                                        billingData.add(Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            const Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  "Delivery Expected in ",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                            Align(
                                                alignment: Alignment.centerLeft,
                                                child:
                                                    Text(delTime.toString())),
                                            const SizedBox(
                                              height: 30,
                                            ),
                                            const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text('Delivery cost '),
                                                Text(
                                                  "\$ 30.00",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10)
                                          ],
                                        ));
                                      } else {
                                        billingData.add(const Column(
                                          children: [
                                            SizedBox(height: 20,),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'Pickup Address',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                  "Sullivangardenrd,Ubibank, Mylapore,Chennai"),
                                            ),
                                            SizedBox(
                                              height: 50,
                                            )
                                          ],
                                        ));
                                      }

                                      billingData.add(Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            "Subtotal",
                                          ),
                                          Text(
                                              "\$ ${prods.fold(0.0, (previousValue, element) {
                                                    return previousValue +
                                                        (element['price'] *
                                                            element[
                                                                'item_count']);
                                                  }) + (delivery ? 30 : 0)}")
                                        ],
                                      ));
                                      billingData.add(Column(
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          ElevatedButton(
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      const MaterialStatePropertyAll(
                                                          primary),
                                                  shape:
                                                      MaterialStatePropertyAll(
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)))),
                                              onPressed: ()async{

                                                if(!(await Prompt.show(msg: "Please confirm your order",ok: "Confirm",cancel: false)) )return;
                                                  Map<String,dynamic>? orders=await db.collection('orders').doc('orders').get();
                                                
                                                orders??={
                                                  "data":[]
                                                };
                                                
                                                List<num> orderIds=orders['data'].fold(<num>[],(p,e){
                                                  p.add(e['id']);
                                                  return p;
                                                });
                                                

                                                for(var item in prods){
                                                  if(orderIds.contains(item['id'])){
                                                    int ind=orderIds.indexOf(item['id']);
                                                    orders['data'][ind]['item_count']+=item['item_count'];
                                                    continue;
                                                  }
                                                  orders['data'].add(item);
                                                }

                                                await db.collection("orders").doc("orders").set(orders);
                                                
                                                await db.collection('cart').delete();

                                                products.value=[];

                                                // for(var item in prods){
                                                //   print(item);
                                                // }

                                                // orders['data'].add()
                                              },
                                              child: const Text(
                                                'Place Your Order',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ))
                                        ],
                                      ));

                                      return Column(
                                        children: billingData,
                                      );
                                    }),
                              ],
                            ),
                          );
                        })
                  ],
                );
              }),
          const Prompt()
        ],
      )),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: light_grey,
        selectedItemColor: primary,
        unselectedItemColor: secondary,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: 1,
        onTap: (int i) {
          Widget? selected;
          switch (i) {
            case 0:
              selected = HomeScreen();
              break;
            case 1:
              selected = CartScreen();
              break;
          }

          if (selected == null) return;

          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (ctx) {
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

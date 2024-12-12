import 'package:ecommerce/config/db.dart';
import 'package:ecommerce/config/reqs.dart';
import 'package:ecommerce/consts/colors.dart';
import 'package:ecommerce/widget/img_change_animation.dart';
import 'package:ecommerce/widget/loading_animation.dart';
import 'package:ecommerce/widget/prompt.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
  ProductScreen({super.key, required this.id}) {
    dio.get("https://api.escuelajs.co/api/v1/products/$id").then((res) {
      db.collection('cart').doc('cart').get().then((data) {
        if (data == null) {
          this.data.value=res.data;
          return;
        }

        if (data['items'].contains(res.data['id'])) {
          addedToCart.value=true;
        }
        this.data.value = res.data;
      });
    });
  }

  final int id;

  final ValueNotifier<Map?> data = ValueNotifier(null);

  final ValueNotifier<int> imgInd = ValueNotifier(0);
  final ValueNotifier<bool> addedToCart = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    GlobalKey<ImgChageAnimationState> imgState = GlobalKey();
    return Scaffold(
      backgroundColor: light_grey,
      body: SafeArea(
        child: Stack(
          children: [
            ValueListenableBuilder(
                valueListenable: data,
                builder: (context, cur, _) {
                  if (cur == null) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 100,
                        ),
                        LoadingAnimation(
                          width: screen.width - 40,
                          height: 600,
                        ),
                      ],
                    );
                  }
                  return Stack(
                    children: [
                      ListView(
                        children: [
                          const SizedBox(
                            height: 100,
                          ),
                          SizedBox(
                            width: screen.width - 40,
                            child: Text(
                              cur["title"],
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              cur['category']['name'],
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 112, 115, 118)),
                            ),
                          ),
                          Row(
                            children: [
                              ImgChageAnimation(
                                imgState,
                                img: cur['images'][0],
                              ),
                              ValueListenableBuilder(
                                  valueListenable: imgInd,
                                  builder: (context, ind, _) {
                                    return Container(
                                        width: 100,
                                        height: 300,
                                        alignment: Alignment.center,
                                        child: ListView.separated(
                                          shrinkWrap: true,
                                          itemCount: cur['images'].length,
                                          itemBuilder: (ctx, i) {
                                            return InkWell(
                                              onTap: () {
                                                print("current state");
                                                print(imgState.currentState);
                                                imgState.currentState
                                                    ?.changeImage(
                                                        cur['images'][i]);

                                                imgInd.value = i;
                                              },
                                              child: Align(
                                                child: Container(
                                                  width: 60,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                      image: DecorationImage(
                                                          image: NetworkImage(
                                                              cur['images'][i]),
                                                          fit: BoxFit.cover),
                                                      border: i == imgInd.value
                                                          ? Border.all(
                                                              color: primary,
                                                              width: 2)
                                                          : null),
                                                ),
                                              ),
                                            );
                                          },
                                          separatorBuilder: (ctx, i) =>
                                              const SizedBox(
                                            height: 20,
                                          ),
                                        ));
                                  }),
                            ],
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 20),
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              'Description',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(cur['description']),
                          ),
                          const SizedBox(
                            height: 100,
                          )
                        ],
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          color: light_grey,
                          width: screen.width,
                          height: 100,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Price",
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 61, 64, 65),
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "\$ ${cur['price'].toString()}",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 21,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                ValueListenableBuilder(
                                  valueListenable: addedToCart,
                                  builder: (context,cartData,_) {
                                    return SizedBox(
                                      height: 70,
                                      child: ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStatePropertyAll(cartData?Colors.transparent:primary),
                                              shape: const MaterialStatePropertyAll(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  8))))),
                                          onPressed: () async {
                                            var items = await db
                                                .collection('cart')
                                                .doc('cart')
                                                .get();
                                            items ??= {"items": []};
                                            if (items['items'].contains(cur['id'])) {
                                              if((await Prompt.show(msg: "Are You Sure Want To Remove This Item From Your Cart",ok: 'No',cancel: 'Yes')))return;
                                              items['items'].remove(cur['id']);
                                            } else {
                                              items['items'].add(cur['id']);
                                            }
                                            await db
                                                .collection('cart')
                                                .doc('cart')
                                                .set({"items": items['items']});
                                            await db.collection('cart').doc(cur['id'].toString()).set({
                                              'item_count':1
                                            });
                                            addedToCart.value=!addedToCart.value;
                                          },
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 50,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(25),
                                                    color: const Color.fromARGB(
                                                        113, 133, 122, 122)),
                                                child: Icon(
                                                  cartData?Icons.delete_forever:Icons.local_mall,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                !cartData?"Add To Cart":"Remove From Cart",
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              )
                                            ],
                                          )),
                                    );
                                  }
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                }),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.white),
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))))),
                    ),
                  ),
                  const SizedBox(
                    width: 50,
                    height: 50,
                    child: IconButton(
                      onPressed: null,
                      icon: Icon(
                        Icons.local_mall,
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
                  )
                ],
              ),
            ),
            const Prompt()
          ],
        ),
      ),
    );
  }
}

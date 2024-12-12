import 'package:ecommerce/consts/colors.dart';
import 'package:flutter/material.dart';

class Prompt extends StatelessWidget {
  const Prompt({super.key});

  static ValueNotifier<Map?> notification = ValueNotifier(null);
  static bool clickedBtn = false;

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return ValueListenableBuilder(
        valueListenable: notification,
        builder: (ctx, note, _) {
          if (note == null) return const SizedBox();

          return Container(
            width: screen.width,
            height: screen.height,
            color: const Color.fromARGB(123, 51, 42, 42),
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
              width: screen.width * .75,
              height: ((note['msg'].length * 2.0) + 100)>screen.height-200?screen.height-200:(note['msg'].length * 2.0) + 100,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: Stack(
                children: [
                  SizedBox(
                    height: ((note['msg'].length * 2.0) + 100)>screen.height-200?screen.height-300:(note['msg'].length * 2.0) ,
                    child: ListView(
                      children: [
                        Text(
                          note['msg'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      height: 80,
                      width: (screen.width*.75)-40,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          (note['cancel'] == false
                              ? const SizedBox()
                              : SizedBox(
                                  height: 50,
                                  child: TextButton(
                                    onPressed: (){
                                      clickedBtn=false;
                                      notification.value=null;
                                    },
                                    style: ButtonStyle(
                                        backgroundColor:
                                            const MaterialStatePropertyAll(
                                                Color.fromARGB(255, 181, 15, 15)),
                                        shape: MaterialStatePropertyAll(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8)))),
                                    child: Text(
                                      note['cancel'],
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )),
                                const SizedBox(width: 20,),
                          (note['ok'] == false
                              ? const SizedBox()
                              : SizedBox(
                                  height: 50,
                                  child: TextButton(
                                    onPressed: (){
                                      clickedBtn=true;
                                      notification.value=null;
                                    },
                                    style: ButtonStyle(
                                        backgroundColor:
                                            const MaterialStatePropertyAll(
                                                Color.fromARGB(255, 33, 127, 56)),
                                        shape: MaterialStatePropertyAll(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8)))),
                                    child: Text(
                                      note['ok'],
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  static Future<bool> show(
      {required String msg,
      dynamic ok = "Okey",
      dynamic cancel = "Cancel"}) async {
    if (ok == false && cancel == false) ok = "Okey";
    notification.value = {"msg": msg, "ok": ok, 'cancel': cancel};
    while (notification.value != null) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    return Prompt.clickedBtn;
  }
}

import 'package:ecommerce/config/db.dart';
import 'package:ecommerce/consts/colors.dart';
import 'package:ecommerce/screens/home_screen.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key,this.nextPage=false});

  TextEditingController name=TextEditingController();
  TextEditingController place=TextEditingController();
  bool nextPage;

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [primary, secondary], begin: Alignment.bottomCenter)),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 20, top: 20),
                alignment: Alignment.topLeft,
                child:  SizedBox(
                  width: 50,
                  height: 50,
                  child: IconButton(
                    onPressed: (){
                      return Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Color.fromARGB(255, 237, 237, 237)),
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5))))),
                  ),
                ),
              ),
              const SizedBox(
                height: 70,
              ),
              const Text(
                'Zstore',
                style: TextStyle(
                    fontFamily: "Header", fontSize: 40, color: Colors.white),
              ),
              const SizedBox(
                height: 70,
              ),
              Container(
                width: screen.width * .85,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(10)),
                child:  TextField(
                  controller: name,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                      hintText: "Enter Your Name Here",
                      contentPadding: EdgeInsets.only(left: 20, right: 20),
                      hintStyle: TextStyle(
                        fontFamily: "Normal",
                        color: Color.fromARGB(255, 197, 197, 197),
                      ),
                      border: InputBorder.none),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Container(
                width: screen.width * .85,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(10)),
                child:  TextField(
                  controller: place,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                      hintText: "Enter Your Place Name Here",
                      contentPadding: EdgeInsets.only(left: 20, right: 20),
                      hintStyle: TextStyle(
                        fontFamily: "Normal",
                        color: Color.fromARGB(255, 197, 197, 197),
                      ),
                      border: InputBorder.none),
                ),
              ),
              const SizedBox(
                height: 70,
              ),
               SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: ()async{
                    // print(name.text);
                    await db.collection('user').doc('1').set({
                      'name':name.text,
                      'place':place.text
                    });
                    await db.collection('config').doc('1').set({
                      'first_time':false
                    });
                    if(nextPage){
                      return Navigator.of(context).pop();
                    }
                    Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
                      return HomeScreen();
                    
                    }));
                    // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx){
                    //   return const HomeScreen();
                    // }), (route) => false);
                  },
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(secondary_shade),
                    side: MaterialStatePropertyAll(BorderSide(color: Colors.white)),
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))))
                  ),
                  child: const Text("GO",style: TextStyle(color: Colors.white,fontFamily: "Normal",fontSize: 18),),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

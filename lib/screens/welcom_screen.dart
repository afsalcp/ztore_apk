import 'package:ecommerce/config/db.dart';
import 'package:ecommerce/consts/colors.dart';
import 'package:ecommerce/screens/home_screen.dart';
import 'package:ecommerce/screens/login_page.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [secondary, primary], begin: Alignment.topCenter),
            image: DecorationImage(
                image: AssetImage(
                  "assets/img/shopping_women.png",
                ),
                fit: BoxFit.contain,
                alignment: Alignment.bottomCenter)),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 30, right: 30),
              margin: const EdgeInsets.only(top: 50),
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: ()async{
                        await db.collection('user').doc('1').set({
                      'name':null,
                      'place':null
                    });
                    Map<String,dynamic>? config=await db.collection('config').doc('1').get();
                    config??={
                      'first_time':false
                    };
                    
                    await db.collection('config').doc('1').set(config);
                    Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=> HomeScreen()));
                    
                      },
                      child: const Text(
                        "Skip",
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: "Normal",
                            color: Colors.white),
                      )),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
                          return  LoginPage();
                        }));
                      },
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Color.fromARGB(67, 96, 69, 102)),
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))),
                        side: MaterialStatePropertyAll(BorderSide(color: Colors.white))
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.arrow_forward,color: Colors.white,),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Get Started",style: TextStyle(color: Colors.white,fontSize: 16,fontFamily: "Normal",letterSpacing: -1),)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              margin: const EdgeInsets.only(top: 100),
              child: const Text("Welcome To",style: TextStyle(color: Colors.white,fontSize: 30,fontFamily: "Normal"),),
            ),
            const SizedBox(height: 10,),
            const Text("Zstore",style: TextStyle(color: Colors.white,fontSize: 40,fontFamily: "Header"),)

          ],
        ),
      ),
    );
  }
}

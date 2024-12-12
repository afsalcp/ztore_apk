import 'dart:io';

import 'package:ecommerce/config/db.dart';
import 'package:ecommerce/consts/colors.dart';
import 'package:ecommerce/screens/home_screen.dart';
import 'package:ecommerce/screens/welcom_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key}){
    db.collection("configs").get().then((data)async{
      if(data==null){
        await Future.delayed(const Duration(milliseconds: 500));
        while(screenctx==null){
          sleep(const Duration(milliseconds: 5));
        }
        Navigator.of(screenctx!).push(MaterialPageRoute(builder: (ctx){
          return const WelcomeScreen();
        }));
        
      }
      else{
        await Future.delayed(const Duration(milliseconds: 500));
        while(screenctx==null){
          sleep(const Duration(milliseconds: 5));
        }
        Navigator.of(screenctx!).push(MaterialPageRoute(builder: (ctx){
          return  HomeScreen();
        }));
      }
    });
  }

  BuildContext? screenctx;

  @override
  Widget build(BuildContext context) {
    screenctx=context;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              // Color.fromARGB(255, 233, 175, 194),
              // Color.fromARGB(255, 246, 100, 148)
              secondary,
              primary
            ],
            begin: Alignment.topCenter,
          ),
        ),
        child: Container(
          alignment: Alignment.bottomCenter,
          margin: const EdgeInsets.only(bottom: 100),
          child: const Text(
            "Zstore",
            style: TextStyle(
                fontSize: 50, fontFamily: "Header", color: Colors.white),
          ),
        ),
      ),
    );
  }
}

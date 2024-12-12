import 'package:ecommerce/consts/colors.dart';
import 'package:ecommerce/screens/cart_screen.dart';
import 'package:ecommerce/screens/home_screen.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Container(
                width: screen.width * .9,
                height: 60,
                decoration:  BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: const [
                    BoxShadow(color: Colors.grey,offset: Offset.zero,spreadRadius: .1,blurRadius: 5),
        
                  ]
                ),
                child:  const TextButton(
                  onPressed: null,
                  style: ButtonStyle(
                    
                  ),
                  child: Text("Change Profle",style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),),
                )),
                const SizedBox(height: 20,),
                Container(
                width: screen.width * .9,
                height: 60,
                decoration:  BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: const [
                    BoxShadow(color: Colors.grey,offset: Offset.zero,spreadRadius: .1,blurRadius: 5),
        
                  ]
                ),
                child:  const TextButton(
                  onPressed: null,
                  style: ButtonStyle(
                    
                  ),
                  child: Text("Your Orders",style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),),
                ))
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        backgroundColor: light_grey,
        selectedItemColor: primary,
        unselectedItemColor: secondary,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (int i) {
          Widget? selected;
          switch (i) {
            case 0:
              selected = HomeScreen();
              break;
            case 1:
              selected = CartScreen();
              break;
            case 3:
              selected = const ProfileScreen();
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

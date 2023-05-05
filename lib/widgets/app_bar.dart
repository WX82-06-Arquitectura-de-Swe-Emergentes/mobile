import 'package:flutter/material.dart';

class AppBarBack extends StatefulWidget {
  const AppBarBack({super.key});

  @override
  State<AppBarBack> createState() => _AppBarBackState();
}

class _AppBarBackState extends State<AppBarBack> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: index,
      onTap: (int i){
        index = i;
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blueGrey,
      iconSize: 25.0,
      selectedFontSize: 14.0,
      unselectedFontSize: 12.0,
      items: const[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '',
          ),
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory_2),
          label: '',
          ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: '',
          ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: '',
          ),
      ]
      );
  }
}
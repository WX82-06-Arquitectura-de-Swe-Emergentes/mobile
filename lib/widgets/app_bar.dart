import 'package:flutter/material.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/screens/chats/chat_list_screen.dart';
import 'package:frontend/screens/trips/trip_screen.dart';
import 'package:frontend/shared/globals.dart';
import 'package:provider/provider.dart';

class AppBarBack extends StatefulWidget {
  const AppBarBack({super.key});

  @override
  State<AppBarBack> createState() => _AppBarBackState();
}

class _AppBarBackState extends State<AppBarBack> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthenticationProvider>(context, listen: false);

    return BottomNavigationBar(
      currentIndex: index,
      onTap: (int i) {
        setState(() {
          if(i == 0){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TripScreen(auth: auth)),
              );
          }
          else if (i == 1) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatListScreen(auth: auth)),
              );
          }
        });
      },
      type: BottomNavigationBarType.fixed,
      backgroundColor: Globals.primaryColor,
      selectedItemColor: index == 1 ? Colors.blue : Colors.blueGrey,
      unselectedItemColor: Colors.blueGrey,
      iconSize: 25.0,
      selectedFontSize: 14.0,
      unselectedFontSize: 12.0,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.question_answer),
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
      ],
    );
  }
}
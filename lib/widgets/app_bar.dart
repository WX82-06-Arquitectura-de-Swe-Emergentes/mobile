import 'package:flutter/material.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/shared/globals.dart';
import 'package:provider/provider.dart';

class AppBarBack extends StatelessWidget implements PreferredSizeWidget {
  const AppBarBack({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthenticationProvider>(context, listen: false);
    final currentIndex = _getCurrentIndex(context);

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (int i) {
        _navigateToScreen(context, i, auth);
      },
      type: BottomNavigationBarType.fixed,
      backgroundColor: Globals.primaryColor,
      selectedItemColor: Globals.redColor,
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

  // modify the method _getRoutes in main.dart to asscoiate the routes with the index
  int _getCurrentIndex(BuildContext context) {
    final routeName = ModalRoute.of(context)?.settings.name;
    switch (routeName) {
      case '/trip':
        return 0;
      case '/chat':
        return 1;
      // case '/cart':
      //   return 2;
      // case '/profile':
      //   return 3;
      default:
        return 0;
    }
  }

  void _navigateToScreen(
      BuildContext context, int index, AuthenticationProvider auth) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    String newRoute = '';
    switch (index) {
      case 0:
        newRoute = '/trip';
        break;
      case 1:
        newRoute = '/chat';
        break;
      // case 2:
      //   newRoute = '/cart';
      //   break;
      // case 3:
      //   newRoute = '/profile';
      //   break;
    }
    if (currentRoute != newRoute) {
      Navigator.pushNamed(context, newRoute);
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 56.0);
}
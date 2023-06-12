import 'package:flutter/material.dart';
import 'package:frontend/firebase/notification/push_notifications_service.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/destination_provider.dart';
import 'package:frontend/providers/season_provider.dart';
import 'package:frontend/providers/trip_provider.dart';
import 'package:frontend/screens/chats/chat_list_screen.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/screens/register_screen.dart';
import 'package:frontend/screens/trips/trip_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  PushNotificationService.initializeApp();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<AuthenticationProvider>(
        create: (_) => AuthenticationProvider(),
      ),
      ChangeNotifierProvider<TripProvider>(create: (_) => TripProvider()),
      ChangeNotifierProvider<SeasonProvider>(create: (_) => SeasonProvider()),
      ChangeNotifierProvider<DestinationProvider>(
          create: (_) => DestinationProvider()),
    ],
    child: const MyApp(),
  ));
}

Map<String, WidgetBuilder> _getRoutes() {
  return {
    '/signin': (context) => const LoginScreen(),
    '/signup': (context) => const RegisterScreen(),
    '/trip': (context) => const TripScreen(),
    '/chat':(context) => const ChatListScreen(),
  };
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, state});

  @override
  State<MyApp> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    
    // Tenemos acceso al context
    PushNotificationService.messagesStream.listen((message) {
      print("Message $message");

      // Navigator.of(context).pushNamed('/chat', arguments: event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.red,fontFamily: 'NunitoSans_10pt'),
      initialRoute: '/signin',
      routes: _getRoutes(),
    );
  }
}

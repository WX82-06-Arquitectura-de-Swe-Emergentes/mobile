import 'package:flutter/material.dart';
import 'package:frontend/firebase/notification/push_notifications_service.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/booking_provider.dart';
import 'package:frontend/providers/destination_provider.dart';
import 'package:frontend/providers/season_provider.dart';
import 'package:frontend/providers/trip_provider.dart';
import 'package:frontend/screens/cart/cart_screen.dart';
import 'package:frontend/screens/chats/chat_conversation_screen.dart';
import 'package:frontend/screens/chats/chat_list_screen.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/screens/profile/profile_screen.dart';
import 'package:frontend/screens/register_screen.dart';
import 'package:frontend/screens/trips/trip_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PushNotificationService.initializeApp();

  Stripe.publishableKey =
      "pk_test_51NEOG0BCaaBopW0JuSz4FUfcLLCJ4jSJw4xEn1EihJEwzVff4e19mGmo8dMnS9WeUxEFb8sSIoxnEeKrsfNT1YSN002vyYOYkQ";
  await dotenv.load(fileName: "assets/.env");

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<AuthenticationProvider>(
        create: (_) => AuthenticationProvider(),
      ),
      ChangeNotifierProvider<BookingProvider>(create: (_) => BookingProvider()),
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
    '/chat': (context) => const ChatListScreen(),
    '/cart': (context) => const CartScreen(),
    '/profile': (context) => const ProfileScreen(),
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
      title: 'AdventureHub',
      theme:
          ThemeData(primarySwatch: Colors.red, fontFamily: 'NunitoSans_10pt'),
      initialRoute: '/signin',
      routes: _getRoutes(),
    );
  }
}

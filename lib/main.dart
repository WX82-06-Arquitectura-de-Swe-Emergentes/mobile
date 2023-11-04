import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend/customer_relationship_communication/infrastructure/notification/fcm/firebase_cloud_messagging_service.dart';
import 'package:frontend/customer_relationship_communication/presentation/customer_relationship_communication/chat_list_screen.dart';
import 'package:frontend/identity_access_management/api/index.dart';
import 'package:frontend/identity_access_management/presentation/identity_access_management/login_screen.dart';
import 'package:frontend/identity_access_management/presentation/identity_access_management/register_screen.dart';
import 'package:frontend/profiles_social_interaction/presentation/profiles_social_interaction/profile_screen.dart';
import 'package:frontend/travel_experience_booking_tracking/api/index.dart';
import 'package:frontend/travel_experience_booking_tracking/presentation/travel_experience_booking_tracking/cart_screen.dart';
import 'package:frontend/travel_experience_design_maintenance/api/index.dart';
import 'package:frontend/travel_experience_design_maintenance/presentation/travel_experience_design_maintenance/trip_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import './injections.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FCMService.initializeApp();

  Stripe.publishableKey =
      "pk_test_51NEOG0BCaaBopW0JuSz4FUfcLLCJ4jSJw4xEn1EihJEwzVff4e19mGmo8dMnS9WeUxEFb8sSIoxnEeKrsfNT1YSN002vyYOYkQ";
  await dotenv.load(fileName: "assets/.env");

  await di.init();

  runApp(MultiProvider(
    providers: [
      /// Identity Access Management
      ChangeNotifierProvider<IdentityAccessManagementApi>(
        create: (_) => IdentityAccessManagementApi(),
      ),

      /// Travel Experience Design Maintenance
      ChangeNotifierProvider<TravelExperienceDesignMaintenanceApi>(
        create: (_) => TravelExperienceDesignMaintenanceApi(),
      ),

      // Travel Experience Booking Tracking
      ChangeNotifierProvider<TravelExperienceBookingTrackingApi>(
        create: (_) => TravelExperienceBookingTrackingApi(),
      ),
    ],
    child: const MyApp(),
  ));
}

Map<String, WidgetBuilder> _getRoutes() {
  return {
    '/signin': (context) => const LoginScreen(), //
    '/signup': (context) => const RegisterScreen(), //
    '/trip': (context) => const TripScreen(), //
    '/chat': (context) => const ChatListScreen(), //
    '/cart': (context) => const CartScreen(), //
    '/profile': (context) => const ProfileScreen(), //
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
    FCMService.messagesStream.listen((message) {
      if (kDebugMode) {
        print("Message $message");
      }

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

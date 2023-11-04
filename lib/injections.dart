import 'package:frontend/identity_access_management/application/identity_access_management_facade_service.dart';
import 'package:frontend/identity_access_management/infrastructure/data_sources/user_remote_provider.dart';
import 'package:frontend/identity_access_management/infrastructure/repositories/user_repository.dart';
import 'package:frontend/travel_experience_booking_tracking/application/travel_experience_booking_tracking_facade_service.dart';
import 'package:frontend/travel_experience_booking_tracking/infrastructure/data_sources/booking_remote_provider.dart';
import 'package:frontend/travel_experience_booking_tracking/infrastructure/repositories/booking_repository.dart';
import 'package:frontend/travel_experience_design_maintenance/application/travel_experience_design_maintenance_facade_service.dart';
import 'package:frontend/travel_experience_design_maintenance/infrastructure/data_sources/trip_remote_provider.dart';
import 'package:frontend/travel_experience_design_maintenance/infrastructure/repositories/trip_repository.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

// From Top To bottom
Future<void> init() async {
  // IAM
  identityAccessManagementDependencies();

  // TEDM
  travelExperienceDesignMaintenanceDependencies();

  // TEBT
  travelExperienceBookingTrackingDependencies();
}

Future<void> identityAccessManagementDependencies() async {
  // Application Layer - facades
  serviceLocator
      .registerLazySingleton(() => IdentityAccessManagementFacadeService(
            repository: serviceLocator(),
          ));

  // Infrastucture Layer - repositories
  serviceLocator.registerLazySingleton(() => UserRepository(
        userRemoteDataProvider: serviceLocator(),
      ));

  // data sources
  serviceLocator.registerLazySingleton(() => UserRemoteDataProvider());
}

Future<void> travelExperienceDesignMaintenanceDependencies() async {
  // Application Layer - facades
  serviceLocator.registerLazySingleton(
      () => TravelExperienceDesignMaintenanceFacadeService(
            repository: serviceLocator(),
          ));

  // Infrastucture Layer - repositories
  serviceLocator.registerLazySingleton(() => TripRepository(
        tripRemoteDataProvider: serviceLocator(),
      ));

  // data sources
  serviceLocator.registerLazySingleton(() => TripRemoteDataProvider());
}

Future<void> travelExperienceBookingTrackingDependencies() async {
  // Application Layer - facades
  serviceLocator
      .registerLazySingleton(() => TravelExperienceBookingTrackingFacadeService(
            repository: serviceLocator(),
          ));

  // Infrastucture Layer - repositories
  serviceLocator.registerLazySingleton(() => BookingRepository(
        bookingRemoteDataProvider: serviceLocator(),
      ));

  // data sources
  serviceLocator.registerLazySingleton(() => BookingRemoteDataProvider());
}

Future<void> customerRelationshipCommunication() async {
  // Application Layer - facades
  // serviceLocator.registerLazySingleton(
  //     () => CustomerRelationshipCommunicationFacadeService(
  //           repository: serviceLocator(),
  //         ));

  // Infrastucture Layer - repositories
  // serviceLocator.registerLazySingleton(() => CommunicationRepository(
  //       communicationRemoteDataProvider: serviceLocator(),
  //     ));

  // data sources
  // serviceLocator.registerLazySingleton(() => CommunicationRemoteDataProvider());
}

import 'package:frontend/identity_access_management/domain/enums/role.dart';

class Authority {
  Authority({
    required this.id,
    required this.name,
  });

  final int id;
  final Role name;
}

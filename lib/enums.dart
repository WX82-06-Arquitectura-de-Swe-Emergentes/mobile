// ignore_for_file: constant_identifier_names

enum Role {
  AGENCY,
  TRAVELER,
  ADMIN,
}

Role? getRoleFromString(String role) {
  for (Role r in Role.values) {
    if (r.toString().split('.').last == role) {
      return r;
    }
  }
  return null;
}

String toStringRole(Role role) {
  return role.toString().split('.').last;
}

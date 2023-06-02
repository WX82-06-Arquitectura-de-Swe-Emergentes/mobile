
import 'package:firebase_database/firebase_database.dart';

class MemberDao {
  final DatabaseReference _memberRef =
      FirebaseDatabase.instance.ref().child('members');


  Query getMemberQuery() => _memberRef;

  DatabaseReference getMemberRef() => _memberRef;
}
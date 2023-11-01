import 'package:firebase_database/firebase_database.dart';

class MemberDao {
  final DatabaseReference _memberRef =
      FirebaseDatabase.instance.ref().child('members');

  Query getMemberQuery() => _memberRef;

  DatabaseReference getMemberRef() => _memberRef;

  Future<dynamic> getMembers(int chatId) async {
    final dataSnapshot = await _memberRef.child(chatId.toString()).once();
    final members = dataSnapshot.snapshot.value;
    return members;
  }
}

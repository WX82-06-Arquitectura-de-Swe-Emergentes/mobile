import 'package:frontend/customer_relationship_communication/domain/entities/member.dart';

class MemberModel extends Member {
  MemberModel({
    required bool isMember,
  }) : super(isMember: isMember);

  factory MemberModel.fromJson(Map<dynamic, dynamic> json) => MemberModel(
        isMember: json['isMember'],
      );

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'isMember': isMember,
      };
}

class Member {
   final bool isMember;

  Member({
    required this.isMember,
  });

  Member.fromJson(Map<dynamic, dynamic> json)
      : isMember = json['isMember'] as bool;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'isMember': isMember,
      };
}

class GroupWork {
  int? id;
  String name;
  String invitationLink;

  GroupWork({this.id, required this.name, required this.invitationLink});

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'invitationLink': invitationLink,
  };

  factory GroupWork.fromMap(Map<String, dynamic> map) => GroupWork(
    id: map['id'],
    name: map['name'] ?? '',
    invitationLink: map['invitationLink'] ?? '',
  );
}

class GroupMember {
  int? id;
  int groupId;
  String memberName;

  GroupMember({this.id, required this.groupId, required this.memberName});

  Map<String, dynamic> toMap() => {
    'id': id,
    'groupId': groupId,
    'memberName': memberName,
  };

  factory GroupMember.fromMap(Map<String, dynamic> map) => GroupMember(
    id: map['id'],
    groupId: map['groupId'] ?? 0,
    memberName: map['memberName'] ?? '',
  );
}

class GroupNote {
  int? id;
  int groupId;
  String title;
  String body;

  GroupNote({
    this.id,
    required this.groupId,
    required this.title,
    required this.body,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'groupId': groupId,
    'title': title,
    'body': body,
  };

  factory GroupNote.fromMap(Map<String, dynamic> map) => GroupNote(
    id: map['id'],
    groupId: map['groupId'] ?? 0,
    title: map['title'] ?? '',
    body: map['body'] ?? '',
  );

  GroupNote copyWith({
    int? id,
    int? groupId,
    String? title,
    String? body,
  }) {
    return GroupNote(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }
}

class GroupMessage {
  int? id;
  int groupId;
  String message;
  int timestamp;

  GroupMessage({
    this.id,
    required this.groupId,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'groupId': groupId,
    'message': message,
    'timestamp': timestamp,
  };

  factory GroupMessage.fromMap(Map<String, dynamic> map) => GroupMessage(
    id: map['id'],
    groupId: map['groupId'] ?? 0,
    message: map['message'] ?? '',
    timestamp: map['timestamp'] ?? 0,
  );
}

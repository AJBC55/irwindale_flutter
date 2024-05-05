class UserIn {
   final String username; 
   final String email; 
   final String password;
  final String first_name; 
  final String last_name;

  UserIn(this.username, this.email, this.password, this.first_name, this.last_name);
}
class UserOut {
  final int id;
  final String username; 
  final String email; 
  final String password_hash;
  final String name_first;
  final String name_last;
  final String created_at;
  
  UserOut(
    {
      required this.id,
      required this.username,
      required this.email,
      required this.password_hash,
      required this.name_first,
      required this.name_last,
      required this.created_at
    });

  factory UserOut.fromJson(Map<String, dynamic> json){
    return UserOut(id: json["id"],
     username: json["username"],
      email: json["email"],
       password_hash: json["password_hash"],
        name_first: json["name_first"],
         name_last: json["name_last"],
         created_at: json["created_at"]);
  }
}
class Event {
  final int id;
  final String name;
  final String description;
  final List<dynamic> time;
  final String img_link;
  final Uri ticket_link;
  final String event_start;
  final bool is_saved;

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.time,
    required this.img_link,
    required this.ticket_link,
    required this.event_start,
    required this.is_saved,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      time: json['time'] ?? [],
      img_link: json['img_link'] ?? '',
      ticket_link: Uri.tryParse(json['ticket_link']) ?? Uri(),
      event_start: json['event_start'].split("T")[0] ?? '',
      is_saved: json['is_saved'] ?? false,);
  }
}
class TokenData { 
  final String token_type;
  final String jwt_token;
  
  TokenData({
    required this.token_type,
    required this.jwt_token});
  
  factory TokenData.fromJson(Map<String, dynamic> json) {
    return TokenData(
      token_type: json["token_type"],
      jwt_token: json["jwt_token"]);
  }
}




class Users {
  int userId;
  String userName;
  String userEmail;
  String userImage;


  Users({this.userName , this.userEmail , this.userImage,this.userId});

  factory Users.fromMap(Map<String , dynamic> map){
    return Users(
      userId: map['userId'],
      userName : map['userName'] ?? 'acc',
      userEmail : map['userEmail'] ?? 'abc',
      userImage : map['userImage'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'userEmail': userEmail,
      'userImage': userImage
    };
  }

}
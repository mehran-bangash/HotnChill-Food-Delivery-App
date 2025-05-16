class UserModel {
  final String? uid;
  final String? email;
  final String? displayName;
  final String? imageUrl;

  UserModel( {this.uid,  this.email, this.displayName,this.imageUrl,});
  Map<String,dynamic> toMap(){
    return {
      "uid":uid,
      "email":email,
      "name":displayName,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      displayName: map['name'],
      imageUrl:map['imageUrl']
    );
  }

}